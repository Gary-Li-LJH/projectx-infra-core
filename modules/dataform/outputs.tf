output "repository_name" {
  description = "The name of the Dataform repository."
  value       = google_dataform_repository.repository.name
}