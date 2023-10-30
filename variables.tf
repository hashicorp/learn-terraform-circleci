# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MIT

variable "region" {
  type        = string
  description = "AWS region for all resources."
}

variable "label" {
  type        = string
  description = "Application label."
}

variable "app" {
  type        = string
  description = "Application name."
}
