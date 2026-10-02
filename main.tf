terraform {

  cloud {
    organization = "giordyhenao"

    workspaces {
      name = "henaogiordy-ws"
    }
  }
}

variable "aws_region" {
  description = "AWS region where the S3 bucket will be created."
  type        = string
  default     = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "this" {
  bucket_prefix = "henaogiordy-terraform-"

  tags = {
    Name        = "henaogiordy-terraform-bucket"
  }
}

output "bucket_name" {
  description = "Name of the S3 bucket created by Terraform."
  value       = aws_s3_bucket.this.bucket
}