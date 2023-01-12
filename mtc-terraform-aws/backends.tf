terraform {
  cloud {
    organization = "aac-aws-terraform"

    workspaces {
      name = "mtc-dev"
    }
  }
}