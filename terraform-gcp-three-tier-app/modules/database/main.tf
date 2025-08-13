# Random password for root user
resource "random_password" "root_password" {
  length  = 16
  special = true
}

# Cloud SQL Instance
resource "google_sql_database_instance" "main" {
  name                = "terraform-db-instance"
  database_version    = "MYSQL_8_0"
  region              = var.region
  deletion_protection = false # Set to true in production

  depends_on = [var.private_ip_range]

  settings {
    tier = "db-f1-micro" # Cheapest option

    backup_configuration {
      enabled                        = true
      start_time                     = "02:00"
      point_in_time_recovery_enabled = false
      backup_retention_settings {
        retained_backups = 7
      }
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/${var.project_id}/global/networks/${var.network_name}"
    }

    database_flags {
      name  = "slow_query_log"
      value = "off"
    }
  }
}

# Database
resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.main.name
}

# Database User
resource "google_sql_user" "user" {
  name     = var.db_user
  instance = google_sql_database_instance.main.name
  password = var.db_password
}