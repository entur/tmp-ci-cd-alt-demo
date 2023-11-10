terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

resource "random_pet" "name" {
  prefix = var.environment
  keepers = {
    trigger = 42
  }
}

output "pet_name" {
  value = random_pet.name
}
