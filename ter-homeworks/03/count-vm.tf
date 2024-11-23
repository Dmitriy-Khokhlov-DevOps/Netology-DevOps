#все переменные находятся в variables.tf

resource "yandex_compute_instance" "develop" {

  count = var.vm_web_quantity

  name        = "netology-develop-platform-web-${count.index+1}"
  hostname    = "netology-develop-platform-web-${count.index+1}"
  platform_id = "standard-v1"

  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type     = var.vm_web_boot_disk_type
      size     = var.vm_web_boot_disk_size
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${var.public_key}"
  }

  scheduling_policy { preemptible = var.vm_web_preemptible }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_web_network_interface_nat
    security_group_ids = [
       yandex_vpc_security_group.example.id
    ]
  }
  allow_stopping_for_update = var.vm_web_allow_stopping_for_update
}
