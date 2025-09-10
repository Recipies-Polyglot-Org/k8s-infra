variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ami" {
  type    = string
  default = "ami-04f59c565deeb2199"
}

variable "instance_type" {
  type    = string
  default = "t2.large"
}

variable "key_name" {
  type    = string
  default = "akshatnv"
}

variable "root_size_gb" {
  type    = number
  default = 80
}

variable "github_org" {
  type    = string
  default = "Recipies-Polyglot-Org"
}

variable "runner_labels" {
  type    = string
  default = "self-hosted,linux,X64"
}

variable "backend_bucket" {
  type = string
  default = "your-unique-bucket-name" # replace or pass via -backend-config
}

variable "backend_key" {
  type = string
  default = "k8s-infra/terraform.tfstate"
}

variable "backend_dynamodb_table" {
  type = string
  default = "terraform-state-lock"
}