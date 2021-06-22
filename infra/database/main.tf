resource "google_sql_database_instance" "postgres" {
  name                = var.database_instance_name
  project             = var.project
  database_version    = "POSTGRES_11"
  region              = var.region
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
    user_labels = {
      "environment" = "dev"
    }
  }
}

resource "google_sql_user" "users" {
  name     = var.sql_user_name
  project  = var.project
  instance = google_sql_database_instance.postgres.name
  password = var.sql_password
}

resource "google_sql_database" "database" {
  name     = var.database_name
  project  = var.project
  instance = google_sql_database_instance.postgres.name
  charset  = "utf8"
}
