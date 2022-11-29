resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a" ## remember to edit this to your liking

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-public-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #open to all IPs by default consider editing to fit your needs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "key"
  public_key = file("~/.ssh/path_to_your_key") #edit this file with the path your SSH key so you can SSH into your EC2 instance
}

resource "aws_instance" "dev_node" {
  instance_type           = "t2.micro"
  ami                     = data.aws_ami.server_ami.id
  key_name                = aws_key_pair.auth.id
  vpc_security_groups_ids = [aws_security_group.sg.id]
  subnet_id               = aws_subnet.public_subnet.id
  user_data = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev-node"
  }

  provisioner "local-exec" 
  command = templatefile("${var.host_os}-ssh-config.tpl", {         ##swap to linux if needed
    hostname = self.public_ip,
    user = "ubuntu",
    identityfile = "~/ssh/key"
  }) 
  interpreter =  var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]                                         
}
