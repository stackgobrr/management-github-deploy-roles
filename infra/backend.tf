terraform {
  backend "s3" {
    bucket  = "stackgobrr-projects-terraform-state"
    key     = "management/github-deploy-roles/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}
