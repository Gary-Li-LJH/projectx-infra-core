module "retail_dataset" {
  source = "./modules/bigquery"

  project_id = var.project_id
  dataset_id = "retail_data"
  friendly_name = "Retail Data"
  description   = "Dataset for retail transaction data"
  location      = var.region

  delete_contents_on_destroy = true

  tables = {
    transactions = {
      schema = jsonencode([
        {
          name = "transaction_id",
          type = "STRING",
          mode = "REQUIRED"
        },
        {
          name = "date",
          type = "DATE",
          mode = "REQUIRED"
        },
        {
          name = "amount",
          type = "FLOAT",
          mode = "REQUIRED"
        }
      ])
    }
  }

  labels = {
    environment = "production"
    department  = "sales"
  }
}