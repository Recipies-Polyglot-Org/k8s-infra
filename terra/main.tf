terraform {
  required_version = ">= 1.1"
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

provider "aws" {
  region = var.aws_region
}

# Render userdata using builtin templatefile() (no token required)
locals {
  userdata_rendered = templatefile("${path.module}/userdata.tpl", {})
}

resource "aws_instance" "runner" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  # default SG will be used when vpc_security_group_ids is omitted
  user_data = local.userdata_rendered

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
