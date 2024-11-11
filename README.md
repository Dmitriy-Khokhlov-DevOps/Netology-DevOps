Домашнее задание к занятию «Введение в Terraform»
![Immm]()
Приложен скриншот вывода команды terraform --version
1) Скачал все необходимые зависимости, использованные в проекте
2) Допустимо сохранить личную, секретную информацию в файле personal.auto.tfvars
3) Результат выполения кода (содержимое terraform.tfstate)

      "type": "random_password",
      "name": "random_string",
             "bcrypt_hash": "$2a$10$6ToWpCwLJL9EmLirJZUetu4RMHxfIUPWER9sTcCIExHscIaQ8Mjiu",
            "id": "none",
            "keepers": null,
            "length": 16,
            "lower": true,
            "min_lower": 1,
            "min_numeric": 1,
            "min_special": 0,
            "min_upper": 1,
            "number": true,
            "numeric": true,
            "override_special": null,
            "result": "4UeMKPBYKrTK2psH",
            "special": false,
            "upper": true

4) В ресурсе "docker_image" отсутствовало имя ресурса "nginx", в ресурсе "docker_container" имя ресурса с ошибкой (должно начинаться с символа, а не с цифры),
   в параметре name ресурса "docker_container" вместо random_string_FAKE.resulT должно быть random_string.result
   
5) Выполнил код. Приложил скриншот команды docker ps
6) Ключ -auto-approve позволяет сразу выполнить код и применить все изменения без подтверждения пользователя. Подходит, если вы точно уверены в правильности кода либо может использоваться в автоматизированых средах,
при этом нужно быть уверенным, что больше никто не вносит изменения в инфраструктуру.
7) Уничтожил ресуры (кроме docker-образа) командой terraform destroy. Прикладываю скриншот команды и скриншот terraform.tfstate
8) Docker-образ не удаляется из-за параметра keep_locally = true
   "keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation."
