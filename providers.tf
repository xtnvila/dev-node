terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region                   = "us-west-2"
  shared_config_files      = "~/.aws/conf"
  shared_credentials_files = "~/.aws/creds"  ## This is your credentials file for the AWS VSCode extension.
  profile                  = "vscode"
}