terraform {
  # backend "local" {
  #   path = "tf-state"
  # }

  backend "pg" {
    conn_str = var.backend_pg_conn_str
  }

  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = "~>4.0"
    }
  }
}

resource "heroku_app" "example" {
  name   = var.heroku_app_name
  region = "us"
}

# Build code & release to the app
resource "heroku_build" "example" {
  app        = heroku_app.example.name
  buildpacks = ["https://github.com/mars/create-react-app-buildpack.git"]

  source {
    url     = "https://github.com/memandip/spotify-clone/archive/refs/tags/v0.1.tar.gz"
    version = "2.1.1"
  }
}

# Launch the app's web process by scaling-up
resource "heroku_formation" "example" {
  app      = heroku_app.example.name
  type     = "web"
  quantity = 1
  size     = "Free"
  depends_on = [
    heroku_build.example
  ]
}
