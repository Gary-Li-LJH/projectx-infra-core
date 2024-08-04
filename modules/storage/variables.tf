# module/storage/variables.tf

variable "project_id" {
  description = "The GCP project ID"
}

variable "region" {
  description = "The GCP region"
}

variable "project_number" {
  description = "The GCP project number"
}

variable "bucket_name" {
  description = "The name of the bucket"
}

variable "uniform_bucket_level_access" {
  description = "Enable uniform bucket-level access"
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type = list(object({
    age    = number
    action = string
  }))
  default = []
}

variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}

variable "enable_notifications" {
  description = "Enable notifications for the bucket"
  type        = bool
  default     = false
}