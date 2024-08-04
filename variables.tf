variable "project_id" {
  description = "The GCP project ID"
  default     = "my-ndf-terraform-proj"
}

variable "region" {
  description = "The GCP region"
  default     = "australia-southeast1"
}

variable "dataset_id" {
  description = "The BigQuery dataset ID"
  default     = "retail_data"
}

variable "dataform_repository_name" {
  description = "The name of the Dataform repository"
  default     = "retail-dataform"
}

variable "cloudbuild_sa_email" {
  description = "The email of the Cloud Build service account"
  default = "cloud-build-service-account@my-ndf-terraform-proj.iam.gserviceaccount.com"
}