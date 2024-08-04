module "retail_dataform" {
  source = "./modules/dataform"

  project_id = var.project_id
  region     = var.region
  repository_name = "retail-dataform"
  git_remote_url  = "https://github.com/your-org/retail-dataform.git"
  git_default_branch = "main"
  git_auth_token_secret_version = "projects/${var.project_id}/secrets/dataform-git-token/versions/latest"
}