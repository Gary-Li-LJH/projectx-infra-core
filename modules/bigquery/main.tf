resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset_id
  friendly_name               = var.friendly_name
  description                 = var.description
  location                    = var.location
  default_table_expiration_ms = var.default_table_expiration_ms

  labels = var.labels

  delete_contents_on_destroy = var.delete_contents_on_destroy
}

resource "google_bigquery_table" "table" {
  for_each = var.tables

  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = each.key

  deletion_protection = false

  schema = each.value.schema

  labels = var.labels
}