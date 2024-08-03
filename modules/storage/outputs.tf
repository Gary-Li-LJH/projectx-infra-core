output "bucket_name" {
  value = google_storage_bucket.data_bucket.name
}

output "network_id" {
  value = google_compute_network.composer_network.id
}

output "subnetwork_id" {
  value = google_compute_subnetwork.composer_subnetwork.id
}