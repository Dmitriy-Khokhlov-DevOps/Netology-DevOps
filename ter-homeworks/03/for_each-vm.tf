#все переменные находятся в variables.tf

resource "yandex_compute_instance" "for_each" {
  depends_on = [yandex_compute_instance.develop]
  for_each = { for i in var.vm_for_each_list : i.vm_name => i }
  name = each.value.vm_name

  platform_id = each.value.platform_id
  resources {
    cores = each.value.cpu
    memory = each.value.ram

  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      size = each.value.disk_volume
    }
  }

    metadata = {
    ssh-keys = "ubuntu:${local.ssh-keys}"
    serial-port-enable = var.for_each_serial-port-enable
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = var.for_each_network_interface_nat
    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }
  scheduling_policy {
    preemptible = var.for_each_preemptible
  }
}
