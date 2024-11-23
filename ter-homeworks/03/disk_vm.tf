#все переменные находятся в variables.tf

resource "yandex_compute_disk" "storage" {
  count = var.storage_secondary_disk[0].count
  type  = var.storage_secondary_disk[0].type
  size  = var.storage_secondary_disk[0].size
  block_size  = var.storage_secondary_disk[0].block_size
  name  = "${var.storage_secondary_disk[0].name}-${count.index}"
}


resource "yandex_compute_instance" "storage" {
  name = var.vm_storage.name
  zone = var.vm_storage.zone

  resources {
    cores  = var.vm_storage.cores
    memory = var.vm_storage.memory
    core_fraction = var.vm_storage.fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type     = var.boot_disk_vm_storage.type
      size     = var.boot_disk_vm_storage.size
    }
  }
      metadata = {
      ssh-keys           = "ubuntu:${local.ssh-keys}"
      serial-port-enable = var.vm_storage_serial-port-enable
    }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_storage_network_interface_nat
    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }
  scheduling_policy {
    preemptible = var.vm_storage_preemptible
  }
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage.*.id
    content {
      disk_id = secondary_disk.value
  }
  }
}