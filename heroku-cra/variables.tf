variable "backend_pg_conn_str" {
  description = "connection string for postgres to store deployment state"
  validation {
    condition     = length(var.backend_pg_conn_str) > 0
    error_message = "Connection string for postgres is required."
  }
}

variable "heroku_app_name" {
  description = "Name of the heroku app provisioned as an example"
  validation {
    condition     = length(var.heroku_app_name) >= 6
    error_message = "Heroku app name must be unique and at least 6 characters."
  }
}
