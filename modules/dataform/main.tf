resource "google_dataform_repository" "repository" {
  provider = google-beta
  project  = var.project_id  # Add this line
  name     = var.repository_name
  region   = var.region

  git_remote_settings {
    url = var.git_remote_url
    default_branch = var.git_default_branch
    authentication_token_secret_version = var.git_auth_token_secret_version
  }
}