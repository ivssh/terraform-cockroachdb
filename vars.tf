variable "env_map" {
  type = "map"
  default = {
    "default"     = "dev"
    "Development" = "dev"
    "Staging"     = "staging"
    "Production"  = "production"
  }
}

variable "vpc_cidr_map" {
  type = "map"
  default = {
    "default"     = "10.18.0.0/16"
    "Development" = "10.18.0.0/16"
    "Staging"     = "10.19.0.0/16"
    "Production"  = "10.20.0.0/16"
  }
}

variable "keypair_map" {
  type = "map"
  default = {
    "default"     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEOxRt6KI77YIcE3DaP/QeZGrqUaK0eLsyS/ZJx2gvaWidEc/qpAe8NZwmlmP6itpp5tgt7TQypGFyWBfeUnKhwauQM8PDGSHr3AykLvxhoWLITG9iRGE0CHVrZFXwd0cJ1V1sW0bmRUGFvzXumXn2XyE15Y/oim/RVUsJ6eBcfsJKLqXOLtH6EZ0jcYFqmxKKfF1O8zdiXqze4n18ktgx5rHAd5YKIoYqmQXI6RXnnkCW7vazsPKrPfhw+M1Pz5F9WGHRFOK5oOupmadjIl8fzM/uq4EWMPGO0GnbTqPa8jd+wAbJmPncvqfI0aD39U9izpK3bQK0eFYQAk2m9ERP abhilash@Admins-MacBook-Pro.local"
    "Development" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEOxRt6KI77YIcE3DaP/QeZGrqUaK0eLsyS/ZJx2gvaWidEc/qpAe8NZwmlmP6itpp5tgt7TQypGFyWBfeUnKhwauQM8PDGSHr3AykLvxhoWLITG9iRGE0CHVrZFXwd0cJ1V1sW0bmRUGFvzXumXn2XyE15Y/oim/RVUsJ6eBcfsJKLqXOLtH6EZ0jcYFqmxKKfF1O8zdiXqze4n18ktgx5rHAd5YKIoYqmQXI6RXnnkCW7vazsPKrPfhw+M1Pz5F9WGHRFOK5oOupmadjIl8fzM/uq4EWMPGO0GnbTqPa8jd+wAbJmPncvqfI0aD39U9izpK3bQK0eFYQAk2m9ERP abhilash@Admins-MacBook-Pro.local"
    "Staging"     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEOxRt6KI77YIcE3DaP/QeZGrqUaK0eLsyS/ZJx2gvaWidEc/qpAe8NZwmlmP6itpp5tgt7TQypGFyWBfeUnKhwauQM8PDGSHr3AykLvxhoWLITG9iRGE0CHVrZFXwd0cJ1V1sW0bmRUGFvzXumXn2XyE15Y/oim/RVUsJ6eBcfsJKLqXOLtH6EZ0jcYFqmxKKfF1O8zdiXqze4n18ktgx5rHAd5YKIoYqmQXI6RXnnkCW7vazsPKrPfhw+M1Pz5F9WGHRFOK5oOupmadjIl8fzM/uq4EWMPGO0GnbTqPa8jd+wAbJmPncvqfI0aD39U9izpK3bQK0eFYQAk2m9ERP abhilash@Admins-MacBook-Pro.local"
    "Production"  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEOxRt6KI77YIcE3DaP/QeZGrqUaK0eLsyS/ZJx2gvaWidEc/qpAe8NZwmlmP6itpp5tgt7TQypGFyWBfeUnKhwauQM8PDGSHr3AykLvxhoWLITG9iRGE0CHVrZFXwd0cJ1V1sW0bmRUGFvzXumXn2XyE15Y/oim/RVUsJ6eBcfsJKLqXOLtH6EZ0jcYFqmxKKfF1O8zdiXqze4n18ktgx5rHAd5YKIoYqmQXI6RXnnkCW7vazsPKrPfhw+M1Pz5F9WGHRFOK5oOupmadjIl8fzM/uq4EWMPGO0GnbTqPa8jd+wAbJmPncvqfI0aD39U9izpK3bQK0eFYQAk2m9ERP abhilash@Admins-MacBook-Pro.local"
  }
}

variable "public_subnet_map" {
  type = "map"
  default = {
    "default"     = "10.18.0.0/22"
    "Development" = "10.18.0.0/22"
    "Staging"     = "10.19.0.0/22"
    "Production"  = "10.20.0.0/22"
  }
}

variable "private_subnet_map_1" {
  type = "map"
  default = {
    "default"     = "10.18.8.0/22"
    "Development" = "10.18.8.0/22"
    "Staging"     = "10.19.8.0/22"
    "Production"  = "10.20.8.0/22"
  }
}

variable "private_subnet_map_2" {
  type = "map"
  default = {
    "default"     = "10.18.12.0/22"
    "Development" = "10.18.12.0/22"
    "Staging"     = "10.19.12.0/22"
    "Production"  = "10.20.12.0/22"
  }
}

variable "cockroach_binary" {
  default = ""
}

# SHA of the cockroach binary to pull down. If none, the latest is fetched.
variable "cockroach_sha" {
  default = ""
}

# Number of instances to start.
variable "num_of_instances" {
  default = 4
}