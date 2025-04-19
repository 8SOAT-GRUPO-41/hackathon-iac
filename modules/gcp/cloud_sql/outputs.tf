output "database_instance_ip_address" {
  value = google_sql_database_instance.default.ip_address
}

output "database_instance_name" {
  value = google_sql_database_instance.default.name
}
