terraform {
  required_version = ">= 1.3.0, <= 1.4.6"

  backend "gcs" {
    bucket = "__BUCKET_NAME__"
    prefix = "terraform/state/google-etl/root"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.17"
    }
  }
}

locals {
  project = "__PROJECT_NAME__"
  region  = "__PROJECT_REGION__"
}

provider "google" {
  project = local.project
  region  = local.region
}
