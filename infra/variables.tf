variable "project_name" {
  description = "Base project name"
  type        = string
  default     = "cobrowse"
}

variable "region" {
  description = "Regions to deploy GCP resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone to deploy GCP resources"
  type        = string
  default     = "us-central1-c"
}

variable "cluster_name" {
  description = "Cluster Name for GKE"
  type        = string
  default     = "gke"
}

