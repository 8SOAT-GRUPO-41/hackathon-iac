resource "google_sql_database_instance" "default" {
  database_version = "POSTGRES_15"
  region           = var.region
  project          = var.project_id

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
    }
  }
}

resource "google_sql_database" "default_db" {
  name     = var.default_database_name
  instance = google_sql_database_instance.default.name
}

resource "google_sql_user" "default" {
  name     = "postgres"
  instance = google_sql_database_instance.default.name
  password = "postgres"
}
