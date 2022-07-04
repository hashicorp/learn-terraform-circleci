terraform {
  cloud {
    organization = "terraform-test007"

    workspaces {
      name = "terraform-circleCI-github-CICD"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.4.0"
    }
  }

  required_version = ">= 1.2.0"
}

