output "dataset_id" {
  description = "The ID of the BigQuery dataset."
  value       = google_bigquery_dataset.dataset.dataset_id
}

output "table_ids" {
  description = "Map of table IDs."
  value       = { for k, v in google_bigquery_table.table : k => v.table_id }
}