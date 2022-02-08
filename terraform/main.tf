terraform {
  required_version = "1.1.2"
  required_providers {
    aws = {
      version = "3.70.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
