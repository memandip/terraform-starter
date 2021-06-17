#  Terraform config to deploy create-react-app `app` to heroku

- This is the sample repo for terraform.
- using heroku provider

** Assuming you have [heroku](https://heroku.com) and [terraform](https://terraform.io) installed **

## steps to run 
- run `./setup.sh heroku-app-name` (replace heroku-app-name with your app name)
  - `./setup.sh` contains all the commands to get your app up and running 
    - it creates heroku app
    - attaches postgresql to your app
    - initialize terraform with backend-config (previously created postgresql database)
    - and finally applies your terraform config
- you will be asked for app-name again
  - it is expected as heroku currently doesn't allow to create postgresql without app atleast for be in the free account
  - working on finding the workaround on this (as it will create one extra app instance just for database)
- the postgresql of the previous app will be used in the app created by terraform during `terraform apply`