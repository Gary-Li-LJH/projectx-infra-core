# module/storage/outputs.tf

output "bucket_name" {
  value       = google_storage_bucket.data_bucket.name
  description = "The name of the GCS bucket"
}

output "bucket_url" {
  value       = google_storage_bucket.data_bucket.url
  description = "The URL of the GCS bucket"
}

output "notification_topic_name" {
  value       = var.enable_notifications ? google_pubsub_topic.new_data_topic[0].name : null
  description = "The name of the Pub/Sub topic for notifications"
}