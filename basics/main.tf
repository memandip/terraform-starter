terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }

    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

# <block> <resource type> <resource name>
# <block> -> block name
# <resource type> -> local=provider, file=resource
# <resource name> -> logical name used to identify the resource name, can be any name
resource "local_file" "pet" {
  filename          = "./root/pets.txt"
  sensitive_content = "We love pets! My favourite pet is ${random_pet.my-pet.id} ."
  depends_on = [
    random_pet.my-pet
  ]

  lifecycle {
    # as the name implies, create the resource first and then destroy older
    create_before_destroy = true

    # prevents destroy of the resource
    # for example, for our database we would not want to destroy it
    prevent_destroy = true

    # ignore changes will be used so that terraform will not reverting back
    # to previous if changes were made outside of terraform
    ignore_changes = [
      filename,
      sensitive_content
    ]
    # if we don't want the resource to be modified after creation.
    # ignore_changes = all
  }
}

resource "random_pet" "my-pet" {
  length    = 1
  prefix    = var.prefix[0]
  separator = " "
}

resource "local_file" "beyond_scope" {
  filename = "./root/beyond_scope.txt"
  content  = data.local_file.dog.content
}

# Data block can be used to get data from outside the scope of terraform
# for example, a database resource was not managed by terraform
# however terraform can read database and use it to provision 
# another application resource managed by terraform
data "local_file" "dog" {
  filename = "./root/dog.txt"
}

# Meta Arguments
# depends_on, lifecycle
resource "random_pet" "another-pet" {
  length = 1
  prefix = each.value
  # only maps or set of strings are iterable
  # converting list to set with builtin terraform function
  for_each  = toset(var.prefix)
  separator = " "
}

resource "random_string" "lorem" {
  length  = 16
  special = false
}

resource "local_file" "name" {
  for_each = var.pets
  filename = "./root/${each.value}.txt"
  content  = random_string.lorem.result
}
