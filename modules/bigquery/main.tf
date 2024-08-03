resource "google_bigquery_dataset" "retail_dataset" {
  dataset_id = var.dataset_id
  location   = var.region
}