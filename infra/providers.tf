terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.72.0"
    }
  }
  backend "gcs" {
    bucket = "tf-state-dev-vntrs"
    prefix = "terraform/state"
  }
}
