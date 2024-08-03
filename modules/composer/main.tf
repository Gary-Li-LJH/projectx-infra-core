resource "google_service_account" "composer_sa" {
  account_id   = "composer-sa"
  display_name = "Service Account for Cloud Composer"
}

resource "google_composer_environment" "airflow" {
  name   = "retail-etl-airflow"
  region = var.region
  
  config {
    software_config {
      image_version = "composer-2.0.31-airflow-2.2.5"
    }

    node_config {
      network    = var.network_id
      subnetwork = var.subnetwork_id
      
      service_account = google_service_account.composer_sa.email
    }
    
    workloads_config {
      scheduler {
        cpu        = 0.5
        memory_gb  = 1.875
        storage_gb = 1
        count      = 1
      }
      web_server {
        cpu        = 0.5
        memory_gb  = 1.875
        storage_gb = 1
      }
      worker {
        cpu        = 0.5
        memory_gb  = 1.875
        storage_gb = 1
        min_count  = 1
        max_count  = 3
      }
    }
  }
}