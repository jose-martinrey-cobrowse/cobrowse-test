terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }
  }
  backend "local" {}
}
# terraform {
#   backend "gcs" {
#     bucket  = "tf-state-prod"
#     prefix  = "terraform/state"
#   }
# }

provider "google" {
  project = "cobrowse-456019"
  region  = "us-central1"
}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.cobrowse.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.cobrowse.master_auth[0].cluster_ca_certificate)

  ignore_annotations = [
    "^autopilot\\.gke\\.io\\/.*",
    "^cloud\\.google\\.com\\/.*"
  ]
}