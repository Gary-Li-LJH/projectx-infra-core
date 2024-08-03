terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }

  backend "gcs" {
    bucket = "my-ndf-terraform-proj-terraform-state"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "storage" {
  source     = "./modules/storage"
  project_id = var.project_id
  region     = var.region
  bucket_name = "${var.project_id}-retail-data"
}

# module "composer" {
#   source     = "./modules/composer"
#   project_id = var.project_id
#   region     = var.region
#   network_id = module.storage.network_id
#   subnetwork_id = module.storage.subnetwork_id
# }

# module "bigquery" {
#   source     = "./modules/bigquery"
#   project_id = var.project_id
#   region     = var.region
#   dataset_id = var.dataset_id
# }

# module "dataform" {
#   source     = "./modules/dataform"
#   project_id = var.project_id
#   region     = var.region
#   repository_name = var.dataform_repository_name
# }

# IAM roles
# resource "google_project_iam_member" "composer_worker" {
#   project = var.project_id
#   role    = "roles/composer.worker"
#   member  = "serviceAccount:${module.composer.service_account_email}"
# }

# resource "google_project_iam_member" "dataflow_worker" {
#   project = var.project_id
#   role    = "roles/dataflow.worker"
#   member  = "serviceAccount:${module.composer.service_account_email}"
# }

# resource "google_project_iam_member" "bigquery_data_editor" {
#   project = var.project_id
#   role    = "roles/bigquery.dataEditor"
#   member  = "serviceAccount:${module.composer.service_account_email}"
# }

# resource "google_project_iam_member" "storage_object_viewer" {
#   project = var.project_id
#   role    = "roles/storage.objectViewer"
#   member  = "serviceAccount:${module.composer.service_account_email}"
# }