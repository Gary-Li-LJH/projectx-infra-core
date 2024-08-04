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