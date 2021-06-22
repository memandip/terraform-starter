variable "heroku_app_name" {
  description = "Heroku app name"
  type        = string
  validation {
    condition     = length(var.heroku_app_name) >= 6
    error_message = "Heroku app name should be at least 6 characters."
  }
}
