# outputs.tf

output "retail_data_bucket_name" {
  value       = module.retail_data_bucket.bucket_name
  description = "The name of the GCS bucket for retail data"
}

output "processed_data_bucket_name" {
  value       = module.processed_data_bucket.bucket_name
  description = "The name of the GCS bucket for processed data"
}

output "retail_data_notification_topic" {
  value       = module.retail_data_bucket.notification_topic_name
  description = "The name of the Pub/Sub topic for retail data notifications"
}