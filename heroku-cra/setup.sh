#! /bin/bash

setup() {
  # cleanup all previous terraform config and local backend state
  rm -rf .terraform

  # setting the appname variable
  appname=$1

  # len=${#appname}

  if [[ ${#appname} -lt 6 ]]; then
    echo "App name must be at least 6 characters long."
    return 0
  fi

  # assuming you have heroku installed locally
  # creating new heroku app
  # app name must be unique
  heroku create $appname

  # creating heroku-postgresql addon with hobby-dev(free tier) plan
  # and attaching it to newly created app
  heroku addons:create heroku-postgresql:hobby-dev --app $appname

  # get database url from heroku app and setting it to variable
  DATABASE_URL=$(heroku config:get DATABASE_URL --app $appname)

  if [[ ${#DATABASE_URL} -lt 152 ]]; then
    echo "DATABASE_URL is required."
    return 0
  fi

  # init terraform with backend-config
  # terraform backend state will be stored in postgresql
  terraform init -backend-config="conn_str=$DATABASE_URL" -var backend_pg_conn_str=$DATABASE_URL

  terraform apply -var backend_pg_conn_str=$DATABASE_URL
}

setup $1
