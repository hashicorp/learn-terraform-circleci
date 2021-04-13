terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.22.0"
    }

    archive = {
      version = "2.1.0"
    }
  }
  required_version = "~> 0.14"

  backend "s3" {
    bucket = "dd4ea9f2-973b-8735-1d6b-32e17c9b7921-api-backend"
    key    = "terraform/webapp/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}

resource "random_uuid" "randomid" {}


resource "aws_s3_bucket" "app" {
  tags = {
    Name = "Api Bucket"
  }

  bucket = "${var.app}.${var.label}.${random_uuid.randomid.result}"
  acl    = "public-read"

  force_destroy = true

}

data "archive_file" "sample_batch" {
    type        = "zip"
    source_dir  = "./sample_batch"
    output_path = "./dist/batch.zip"
}


resource "aws_s3_bucket_object" "app" {
  acl          = "public-read"
  key          = "batch.zip"
  bucket       = aws_s3_bucket.app.id
  content      = data.archive_file.sample_batch.output_path
  content_type = "text/html"
}

output "api_s3_bucket" {
  value = aws_s3_bucket.app.bucket
}
