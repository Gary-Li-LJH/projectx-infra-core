resource "google_storage_bucket" "data_bucket" {
  name     = var.bucket_name
  location = var.region
  force_destroy = true
}

resource "google_compute_network" "composer_network" {
  name                    = "composer-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "composer_subnetwork" {
  name          = "composer-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.composer_network.id
}