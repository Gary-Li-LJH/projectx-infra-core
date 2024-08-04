# storage.tf

module "retail_data_bucket" {
  source = "./module/storage"

  project_id  = var.project_id
  region      = var.region
  project_number = var.project_number
  bucket_name = "retail-data"

  lifecycle_rules = [
    {
      age    = 30
      action = "Delete"
    }
  ]

  enable_versioning   = true
  enable_notifications = true
}

module "processed_data_bucket" {
  source = "./module/storage"

  project_id  = var.project_id
  region      = var.region
  project_number = var.project_number
  bucket_name = "processed-retail-data"

  lifecycle_rules = [
    {
      age    = 60
      action = "Delete"
    }
  ]

  enable_versioning   = true
  enable_notifications = false
}