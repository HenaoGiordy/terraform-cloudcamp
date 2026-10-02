terraform {

  cloud {
    organization = "giordyhenao"

    workspaces {
      name = "henaogiordy-ws"
    }
  }
}

variable "aws_region" {
  description = "AWS region where the infrastructure will be created."
  type        = string
  default     = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}

