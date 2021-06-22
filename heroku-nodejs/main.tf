terraform {
  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = "~>4.0"
    }
  }
}

resource "heroku_app" "heroku-nodejs" {
  name = var.heroku_app_name
}