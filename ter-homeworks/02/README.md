### Задание 1
1. Изучил проект
2. Создал сервисный аккаунт и ключ
3. Сгенерировал новый ssh-ключ и записал в переменную
4. Ошибки инициализации проекта из-за 1) platform_id = "standart-v4" - ошибка в слове и версия другая. Поставил standard-v1 (взял из вебинара) 2) кол-во ядер=2 тоже взял из вебинара, с 1 ядром не инициализируется
5. Подключился к консоли ВМ через ssh
6. preemptible = true означает, что виртуальные машины могут быть принудительно остановлены в любой момент. Такие ВМ стоят дешевле
7. core_fraction=5 означает уровень производительности vCPU в процентах. Влияет на стоимость ВМ
8. ![VM Yandex Cloud](https://github.com/Dmitriy-Khokhlov-DevOps/Netology-DevOps/blob/main/ter-homeworks/02/vm_yandex_cloud.png)
9. ![curl ifconfig.me](https://github.com/Dmitriy-Khokhlov-DevOps/Netology-DevOps/blob/main/ter-homeworks/02/ifconfig.png)

### Задание 2
1. Заменил хардкод-значения на переменные. Проверил terraform plan. Все норм


resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_res_cores
    memory        = var.vm_web_res_memory
    core_fraction = var.vm_web_res_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_nat
  }

  metadata = {
    serial-port-enable = var.vm_web_serial-port-enable
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}

### Задание 3
Сделал, но не понял как создать первую машину в одной зоне, а вторую в другой. В файле providers объявляется провайдер яндекс с зоной по умолчанию А. Если у второй машины при создании установить зону В, то выдается ошибка. Причем подсети одной сети создаются в разных зонах, а машины - нет.  Конечно, можно это сделать за 2 прохода по отдельности. Но хотелось бы за один раз.

Содержимое  main.cf
#VM WEB

resource "yandex_vpc_network" "netology" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "develop" {
  name           = var.vm_web_vpc_name
  zone           = var.vm_web_default_zone
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = var.vm_web_default_cidr
}

data "yandex_compute_image" "ubuntu_web" {
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform_web" {
  name        = var.vm_web_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_res_cores
    memory        = var.vm_web_res_memory
    core_fraction = var.vm_web_res_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_web.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_nat
  }

  metadata = {
    serial-port-enable = var.vm_web_serial-port-enable
    ssh-keys           = "ubuntu_web:${var.vm_web_vms_ssh_root_key}"
  }

}

#VM DB

resource "yandex_vpc_subnet" "db" {
  name           = var.vm_db_vpc_name
  zone           = var.vm_db_default_zone
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = var.vm_db_default_cidr
}

data "yandex_compute_image" "ubuntu_db" {
  family = var.vm_db_family
}
resource "yandex_compute_instance" "platform_db" {
  name        = var.vm_db_name
  platform_id = var.vm_db_platform_id
  resources {
    cores         = var.vm_db_res_cores
    memory        = var.vm_db_res_memory
    core_fraction = var.vm_db_res_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_db.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.db.id
    nat       = var.vm_db_nat
  }

  metadata = {
    serial-port-enable = var.vm_db_serial-port-enable
    ssh-keys           = "ubuntu_db:${var.vm_db_vms_ssh_root_key}"
  }

} 


Содержимое variables.tf


###cloud vars

variable "vm_web_family" {
  type        = string
  default = "ubuntu-2004-lts"
  description = "Image family"
}

variable "vm_web_name" {
  type        = string
  default = "netology-develop-platform-web"
  description = "Platform name"
}

variable "vm_web_platform_id" {
  type        = string
  default = "standard-v1"
  description = "Platform ID"
}

variable "vm_web_res_cores" {
  type        = number
  default = 2
  description = "Cores"
}

variable "vm_web_res_memory" {
  type        = number
  default = 1
  description = "Memory"
}

variable "vm_web_res_core_fraction" {
  type        = number
  default = 5
  description = "Core fraction"
}

variable "vm_web_preemptible" {
  type        = bool
  default = true
}

variable "vm_web_nat" {
  type        = bool
  default = true
}

variable "vm_web_serial-port-enable" {
  type        = number
  default = 1
}

variable "cloud_id" {
  type        = string
  default = "b1gm0e3k3s85f6hioem6"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default = "b1g22sh1ea4voag0p3tl"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "vm_web_default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "vm_web_default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "netology"
  description = "VPC network & subnet name"
}

variable "vm_web_vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vm_db_vpc_name" {
  type        = string
  default     = "db"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vm_web_vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGqG3HLLQ5g0ZZsjaXFvVUZMDlcqQC5vLg4Vu7aVZhUA netology-vm"
  description = "ssh-keygen -t ed25519"
}


Содержимое vms_platform.tf

###cloud vars

variable "vm_db_family" {
  type        = string
  default = "ubuntu-2004-lts"
  description = "Image family"
}

variable "vm_db_name" {
  type        = string
  default = "netology-develop-platform-db"
  description = "Platform name"
}

variable "vm_db_platform_id" {
  type        = string
  default = "standard-v1"
  description = "Platform ID"
}

variable "vm_db_res_cores" {
  type        = number
  default = 2
  description = "Cores"
}

variable "vm_db_res_memory" {
  type        = number
  default = 2
  description = "Memory"
}

variable "vm_db_res_core_fraction" {
  type        = number
  default = 20
  description = "Core fraction"
}

variable "vm_db_preemptible" {
  type        = bool
  default = true
}

variable "vm_db_nat" {
  type        = bool
  default = true
}

variable "vm_db_serial-port-enable" {
  type        = number
  default = 1
}

variable "vm_db_default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vm_db_default_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

###ssh vars

variable "vm_db_vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGqG3HLLQ5g0ZZsjaXFvVUZMDlcqQC5vLg4Vu7aVZhUA netology-vm"
  description = "ssh-keygen -t ed25519"
}

![VMs](https://github.com/Dmitriy-Khokhlov-DevOps/Netology-DevOps/blob/main/ter-homeworks/02/ter-homeworks-02-3-1.png)

![Subnets](https://github.com/Dmitriy-Khokhlov-DevOps/Netology-DevOps/blob/main/ter-homeworks/02/ter-homeworks-02-3-2.png)

### Задание 4

Содержимое outputs.tf

output "info" {
  value = {
    instance_web = yandex_compute_instance.platform_web.name
    instance_db = yandex_compute_instance.platform_db.name
    public_ip_web = yandex_compute_instance.platform_web.network_interface.0.nat_ip_address
    public_ip_db = yandex_compute_instance.platform_db.network_interface.0.nat_ip_address
  }
}

![outputs](https://github.com/Dmitriy-Khokhlov-DevOps/Netology-DevOps/blob/main/ter-homeworks/02/ter-homeworks-02-4-1.png)

### Задание 5

Содержимое locals.tf

locals {
  common_platform_name = "netology-develop-platform"
  add_web = "web"
  add_db = "db"
  vm_web_platform_name = "${local.common_platform_name}-${local.add_web}"
  vm_db_platform_name = "${local.common_platform_name}-${local.add_db}"
} 

Поменял перменные в main.cf. Проверил.

### Задание 6


