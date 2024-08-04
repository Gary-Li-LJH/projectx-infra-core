resource "google_storage_bucket" "bucket" {
  name     = "${var.project_id}-${var.bucket_name}"
  location = var.region

  uniform_bucket_level_access = true
  force_destroy               = true

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