# <block> <resource type> <resource name>
# <block> -> block name
# <resource type> -> local=provider, file=resource
# <resource name> -> logical name used to identify the resource name, can be any name
resource "local_file" "pet" {
  filename          = "./root/pets.txt"
  sensitive_content = "We love pets!"
}

resource "random_pet" "name" {
  length    = 5
  prefix    = var.prefix[0]
  separator = "."
}
