terraform {
  backend "s3" {
    bucket         = var.backend_bucket     # or hardcode the name
    key            = var.backend_key        # e.g. "k8s-infra/terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = var.backend_dynamodb_table
    encrypt        = true
  }
}
