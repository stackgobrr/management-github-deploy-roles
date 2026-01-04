variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "github_org" {
  description = "GitHub organization name"
  type        = string
  default     = "stackgobrr"
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}
