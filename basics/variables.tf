variable "prefix" {
  default = ["Mr", "Mrs", "Sir"]
  type    = list(string)
}

# Similar to list, only difference, it cannot have duplicate values
# variable "prefix" {
#   default = ["Mr", "Mrs", "Sir", "Sir"]
#   type    = set(string)
# }

variable "file-content" {
  default = {
    "content-1" = "Exampleof content 1"
  }
  type = map(string)
}

variable "bella" {
  type = object({
    name          = string
    color         = string
    food          = list(string)
    favourite_pet = bool
  })

  default = {
    color         = "blue"
    favourite_pet = false
    food          = ["momo", "chowmin"]
    name          = "test"
  }
}

variable "tuple_test" {
  type    = tuple([string, number, bool])
  default = ["cat", 1, false]
}
