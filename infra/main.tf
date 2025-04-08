resource "google_compute_network" "k8s-default" {
  name                     = "${var.project_name}-network"
  auto_create_subnetworks  = false
  enable_ula_internal_ipv6 = true
}

resource "google_compute_subnetwork" "subnetwork" {
  name = "${var.project_name}-subnetwork"

  ip_cidr_range = "10.0.0.0/16"
  region        = var.region


  network = google_compute_network.k8s-default.id
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.0.0/24"
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.1.0/24"
  }
}

resource "google_container_cluster" "cobrowse" {
  name                = "${var.project_name}-${var.cluster_name}"
  location            = var.zone
  initial_node_count  = 2
  deletion_protection = false
  network             = google_compute_network.k8s-default.id
  subnetwork          = google_compute_subnetwork.subnetwork.id
  ip_allocation_policy {
    services_secondary_range_name = google_compute_subnetwork.subnetwork.secondary_ip_range[0].range_name
    cluster_secondary_range_name  = google_compute_subnetwork.subnetwork.secondary_ip_range[1].range_name
  }
}


resource "kubernetes_namespace" "cobrowse" {
  metadata {
    annotations = {
      name = var.project_name
    }
    name = var.project_name
  }
}

resource "google_compute_disk" "static_pv" {
  name = "${var.project_name}-disk"
  size = 10
  type = "pd-standard"
  zone = var.zone
}
