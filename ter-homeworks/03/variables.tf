###cloud vars

variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vm_web_quantity" {
  type        = number
  default     = 2
  description = "vm_web_quantity"
}

variable "vm_web_cores" {
  type        = number
  default = 2
  description = "Cores"
}

variable "vm_web_memory" {
  type        = number
  default = 1
  description = "Memory"
}

variable "vm_web_fraction" {
  type        = number
  default = 20
  description = "Core fraction"
}

variable "vm_web_preemptible" {
  type        = bool
  default = true
}

variable "vm_web_boot_disk_type" {
  type        = string
  default = "network-hdd"
}

variable "vm_web_boot_disk_size" {
  type        = number
  default = 5
}

variable "vm_web_network_interface_nat" {
  type        = bool
  default = true
}

variable "vm_web_allow_stopping_for_update" {
  type        = bool
  default = true
}

variable "public_key" {
  type        = string
  description = "ssh-keygen -t ed25519"
}

variable "vm_for_each_list" {
  type = list(object({
    vm_name = string
    cpu     = number
    ram     = number
    disk_volume    = number
    platform_id = string
  }))

  default = [
    {
      vm_name = "main"
      cpu     = 4
      ram     = 4
      disk_volume    = 6
      platform_id = "standard-v1"
    },
    {
      vm_name = "replica"
      cpu     = 2
      ram     = 4
      disk_volume    = 7
      platform_id = "standard-v1"
    },
  ]
}

locals {
  ssh-keys = file("~/.ssh/id_ed25519.pub")
}

variable "for_each_serial-port-enable" {
  type        = number
  default = 1
}

variable "for_each_network_interface_nat" {
  type        = bool
  default = true
}

variable "for_each_preemptible" {
  type        = bool
  default = true
}

variable "vm_storage" {
  type = object({
    cores = number
    memory = number
    fraction = number
    name = string
    zone = string
    })

  default = {
    cores = 2
    memory = 2
    fraction = 5
    name = "storage"
    zone = "ru-central1-a"
    }
  }

variable "boot_disk_vm_storage" {
  type = object({
    size = number
    type = string
  })
  default = {
    size = 5
    type = "network-hdd"
  }
}

variable "storage_secondary_disk" {
  type = list(object({
    type  = string
    size = number
    count = number
    block_size = number
    name = string
    }))

  default = [
    {
    type = "network-hdd"
    size = 1
    count = 3
    block_size = 4096
    name = "disk"
    }
  ]
}

variable "vm_storage_preemptible" {
  type        = bool
  default = true
}

variable "vm_storage_serial-port-enable" {
  type        = number
  default = 1
}

variable "vm_storage_network_interface_nat" {
  type        = bool
  default = true
}
