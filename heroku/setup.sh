#! /bin/bash

setup() {
  appname=$1

  # len=${#appname}

  if [[ ${#appname} -lt 6 ]]; then
    echo "App name must be at least 6 characters long."
    return 0
  fi

  # assuming you have heroku installed locally
  heroku create $appname

  heroku addons:create heroku-postgresql:hobby-dev --app $appname

  export DATABASE_URL=$(heroku config:get DATABASE_URL --app $appname)

  terraform init -backend-config="conn_str=$DATABASE_URL"
}

setup $1
