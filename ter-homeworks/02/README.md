### Задание 1
1. Изучил проект
2. Создал сервисный аккаунт и ключ
3. Сгенерировал новый ssh-ключ и записал в переменную
4. Ошибки инициализации проекта из-за 1) platform_id = "standart-v4" - ошибка в слове и версия другая. Поставил standard-v1 (взял из вебинара) 2) кол-во ядер=2 тоже взял из вебинара, с 1 ядром не инициализируется
5. Подключился к консоли ВМ через ssh
6. preemptible = true означает, что виртуальные машины могут быть принудительно остановлены в любой момент. Такие ВМ стоят дешевле
7. core_fraction=5 означает уровень производительности vCPU в процентах. Влияет на стоимость ВМ
8. ![VM Yandex Cloud](https://github.com/Dmitriy-Khokhlov-DevOps/Netology-DevOps/edit/main/ter-homeworks/02/vm_yandex_cloud.png)
9. ![curl ifconfig.me](https://github.com/Dmitriy-Khokhlov-DevOps/Netology-DevOps/edit/main/ter-homeworks/02/vm_yandex_cloud.png)
