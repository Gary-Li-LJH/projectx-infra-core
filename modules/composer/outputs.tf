output "airflow_uri" {
  value = google_composer_environment.airflow.config[0].dag_gcs_prefix
}

output "service_account_email" {
  value = google_service_account.composer_sa.email
}