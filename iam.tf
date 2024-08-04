# Cloud Build Service Account (already exists, we're just referencing it)
data "google_service_account" "cloud_build_sa" {
  account_id = "cloud-build-service-account@${var.project_id}.iam.gserviceaccount.com"
}

# Additional roles for Cloud Build SA (if needed)
resource "google_project_iam_member" "cloud_build_sa_additional_roles" {
  for_each = toset([
    "roles/compute.networkAdmin",
    "roles/bigquery.admin",
    "roles/dataflow.admin",
    "roles/composer.admin",
    "roles/dataform.admin"
  ])
  
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${data.google_service_account.cloud_build_sa.email}"
}

# ETL Service Account
resource "google_service_account" "etl_sa" {
  account_id   = "etl-service-account"
  display_name = "ETL Service Account"
}

# Roles for ETL SA
resource "google_project_iam_member" "etl_sa_roles" {
  for_each = toset([
    "roles/storage.objectViewer",
    "roles/bigquery.dataEditor",
    "roles/dataflow.worker"
  ])
  
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.etl_sa.email}"
}