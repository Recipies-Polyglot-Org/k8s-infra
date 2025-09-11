terraform {
  backend "s3" {
    bucket         = "akshat-recipes-polyglot-tfstate"    # or hardcode the name
    key            = "k8s-infra/terraform.tfstate"       # e.g. "k8s-infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "akshat-recipes-polyglot-locks"
    encrypt        = true
  }
}
