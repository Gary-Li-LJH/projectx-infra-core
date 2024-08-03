resource "google_dataform_repository" "retail_dataform" {
  provider = google-beta
  
  name     = var.repository_name
  region   = var.region
}