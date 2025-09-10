variable "aws_region" { type = string }
variable "ami" { type = string }
variable "instance_type" { type = string }
variable "key_name" { type = string }
variable "root_size_gb" { type = number }
variable "github_org" { type = string }
variable "runner_labels" { type = string }
variable "runner_reg_token" { type = string, sensitive = true }
