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


