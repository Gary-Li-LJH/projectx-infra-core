module "retail_data_bucket" {
  source = "./modules/storage"

  project_id  = var.project_id
  region      = var.region
  bucket_name = "retail-data"

  lifecycle_rules = [
    {
      age    = 30
      action = "Delete"
    }
  ]

  enable_versioning = true
}

module "processed_data_bucket" {
  source = "./modules/storage"

  project_id  = var.project_id
  region      = var.region
  bucket_name = "processed-retail-data"

  lifecycle_rules = [
    {
      age    = 60
      action = "Delete"
    }
  ]

  enable_versioning = true
}