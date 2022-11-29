# Dev node

### A Terraform template that deploys a fully configured AWS EC2 instance, with subnet, internet gateway, security group and custom user data, is also accessible via VSCode ssh extension.

## Installation and Setup

### AWS

Go to your IAM services in AWS console and add an user, I went with 'vscode' for this template but you can name it to your liking. Remember to edit 'profile name' on line 13 of `providers.tf`, also you might want to edit your region. Remember to add all the needed policies/permissions.

### SSH Access

This template is deisgned to work with VSCode under any OS. You´will need the AWS Toolkit extension with the correct credentials, is by default stored under `~/.aws/creds` but you can edit this path in `providers.tf`, you only need to add your Acess Key ID and Secret Access Key.

You can access your EC2 instance via SSH using an external client just fine, but it will work with the **Remote - SSH VSCode extension** remember to replace your username in the first line of `windows-ssh-config.tpl` if you are on windows or `linux-ssh-config.tpl` if you are using Linux or OSX, if that´s the case you´ll have to edit line 91 in `main.tf` and the `host_os` variable under `variables.tf`.

Finally you need to generete an ssh key pair to connect with your EC2 instance, the default path to this file is in line is in line 71 of `main.tf` and you´re good to go.

### Final details

By default the security group of this instance comes open for every IP, you might not want that you can restrict external access in line 58 of `main.tf`. Also the default region and AZ comes as us-west-2 in lines 15 of `main.tf` and 11 of `providers.tf`.

If you run into any trouble or have any questions dont hesitante in contacting me, I´ll be happy to help.






