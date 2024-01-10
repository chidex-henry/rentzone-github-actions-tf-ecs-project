# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "henry-terraform-github-action-state"
    key            = "rentzone-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}
