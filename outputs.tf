# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MIT

output "endpoint" {
  value = "${aws_s3_bucket.app.bucket_domain_name}/index.html"
}
