# module/storage/main.tf

resource "google_storage_bucket" "data_bucket" {
  name     = "${var.project_id}-${var.bucket_name}"
  location = var.region
  
  uniform_bucket_level_access = var.uniform_bucket_level_access

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      condition {
        age = lifecycle_rule.value.age
      }
      action {
        type = lifecycle_rule.value.action
      }
    }
  }

  versioning {
    enabled = var.enable_versioning
  }
}

resource "google_storage_notification" "notification" {
  count          = var.enable_notifications ? 1 : 0
  bucket         = google_storage_bucket.data_bucket.name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.new_data_topic[0].id
  event_types    = ["OBJECT_FINALIZE"]
  
  depends_on = [google_pubsub_topic_iam_binding.binding]
}

resource "google_pubsub_topic" "new_data_topic" {
  count = var.enable_notifications ? 1 : 0
  name  = "${var.bucket_name}-notification-topic"
}

resource "google_pubsub_topic_iam_binding" "binding" {
  count  = var.enable_notifications ? 1 : 0
  topic  = google_pubsub_topic.new_data_topic[0].id
  role   = "roles/pubsub.publisher"
  members = ["serviceAccount:${var.project_number}@gs-project-accounts.iam.gserviceaccount.com"]
}