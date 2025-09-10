variable "region" {
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Unique S3 bucket name for terraform state (must be globally unique)"
  default     = "akshat-terraform-state"
}

variable "dynamodb_table" {
  type    = string
  default = "akshat-terraform-locks"
}

variable "environment" {
  type    = string
  default = "prod"
}
