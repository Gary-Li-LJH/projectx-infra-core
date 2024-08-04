variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "region" {
  description = "The region of the repository."
  type        = string
}

variable "repository_name" {
  description = "The name of the repository."
  type        = string
}

variable "git_remote_url" {
  description = "The URL of the Git repository."
  type        = string
}

variable "git_default_branch" {
  description = "The default branch of the Git repository."
  type        = string
  default     = "main"
}

variable "git_auth_token_secret_version" {
  description = "The Cloud Secret Manager secret version for the Git authentication token."
  type        = string
}