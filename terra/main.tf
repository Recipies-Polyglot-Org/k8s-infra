terraform {
  required_version = ">= 1.1"
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region"    { type = string, default = "us-east-1" }
variable "ami"           { type = string, default = "ami-04f59c565deeb2199" }
variable "instance_type" { type = string, default = "t2.large" }
variable "key_name"      { type = string, default = "akshatnv" }
variable "root_size_gb"  { type = number, default = 80 }
variable "github_org"    { type = string, default = "Recipies-Polyglot-Org" }
variable "runner_labels" { type = string, default = "self-hosted,linux,X64" }

# ephemeral registration token passed from workflow
variable "runner_reg_token" { type = string, sensitive = true }

# Use the default security group in the account/VPC
data "aws_default_security_group" "default" {}

data "template_file" "userdata" {
  template = file("${path.module}/userdata.tpl")
  vars = {
    registration_token = var.runner_reg_token
    github_org         = var.github_org
    runner_labels      = var.runner_labels
  }
}

resource "aws_instance" "runner" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [data.aws_default_security_group.default.id]
  user_data              = data.template_file.userdata.rendered

  root_block_device {
    volume_size = var.root_size_gb
    volume_type = "gp3"
  }

  tags = {
    Name = "Akshat-terra"
  }
}

output "runner_public_ip" {
  value = aws_instance.runner.public_ip
}
