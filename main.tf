terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "rachel-test"

    workspaces {
      name = "TF-Circle-Demo"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "template" {
}

resource "aws_iam_user" "circleci" {
  name = var.user
  path = "/system/"
}

resource "aws_iam_access_key" "circleci" {
  user = aws_iam_user.circleci.name
}

data "template_file" "circleci_policy" {
  template = file("circleci_s3_access.tpl.json")
  vars = {
    s3_bucket_arn = aws_s3_bucket.portfolio.arn
  }
}

resource "local_file" "circle_credentials" {
  filename = "tmp/circleci_credentials"
  content  = "${aws_iam_access_key.circleci.id}\n${aws_iam_access_key.circleci.secret}"
}

resource "aws_iam_user_policy" "circleci" {
  name   = "AllowCircleCI"
  user   = aws_iam_user.circleci.name
  policy = data.template_file.circleci_policy.rendered
}

data "aws_route53_zone" "selected" {
  name         = "${var.zone}."
  private_zone = false
}

resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.app}.${var.zone}"
  type    = "A"

  alias {
    name                   = aws_s3_bucket.portfolio.website_domain
    zone_id                = aws_s3_bucket.portfolio.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_s3_bucket" "portfolio" {
  tags = {
    Name = "Portfolio Website Bucket"
  }

  bucket = "${var.app}.${var.zone}"
  acl    = "public-read"

  website {
    index_document = "${var.app}.html"
    error_document = "error.html"
  }
  force_destroy = true

}

output "Endpoint" {
  value = aws_s3_bucket.portfolio.website_endpoint
}
