# terraform starter

- This is the sample repo for terraform.
- using docker provider with nginx

## steps to run sample
- install [terraform](https://terraform.io)
- run `terraform init`
- run `terraform apply`
  - this command will read your `main.tf` file
  - on successful you will be able to visit http://localhost:9000 and see nginx landing page
- run `terraform destroy`
  - will destroy all your resources