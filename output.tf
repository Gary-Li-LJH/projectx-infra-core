output "retail_data_bucket_name" {
  value       = module.retail_data_bucket.bucket_name
  description = "The name of the GCS bucket for retail data"
}

output "retail_data_bucket_url" {
  value       = module.retail_data_bucket.bucket_url
  description = "The URL of the GCS bucket for retail data"
}

output "processed_data_bucket_name" {
  value       = module.processed_data_bucket.bucket_name
  description = "The name of the GCS bucket for processed data"
}

output "processed_data_bucket_url" {
  value       = module.processed_data_bucket.bucket_url
  description = "The URL of the GCS bucket for processed data"
}

output "bigquery_dataset_id" {
  value       = module.retail_dataset.dataset_id
  description = "The ID of the BigQuery dataset"
}

output "dataform_repository_name" {
  value       = module.retail_dataform.repository_name
  description = "The name of the Dataform repository"
}