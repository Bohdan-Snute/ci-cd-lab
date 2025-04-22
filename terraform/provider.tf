provider "aws" {
  region     = "eu-north-1" # або яка в тебе є
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
