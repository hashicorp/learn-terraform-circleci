terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "remote" {
        organization = "yordanh_free"
        workspace = "11111111"
    }
}


