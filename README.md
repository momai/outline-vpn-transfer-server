# Набор скриптов для переноса сервера Outline с одного сервера hetzner на другой.

Результатом выполнения скрипта будет вывод строки для вставки в Outline Manager, где вы найдете свой сервер под новым адресом со всеми настройками и ключами.

#### Пример вывода:

```{'apiUrl':'https://1.1.1.1:11111/DFGKkVMKQ3-5FGDFLM','certSha256':'SDFGKDLFMGERSDFKMSDKLFMW'}```



## Предварительные настройки:

1. Установите ansible и terraform
2. Склонируйте репозиторий
3. Установите ansible-galaxy collection install community.dns
4. Возможно, необходимо будет выполнить требования по terraform (дополняется)
5. Добавить публичный ключ, и создать два токена в hetzner cloud и hetzner dns

## Первое использование:

### I. При наличии уже существующего outline server на hetzner

1. Замените в `vars.yml` old_server_ip на необходимый
2. Закомментируйте первый task в `move_outline.yml`:

```
- name: Get old server IP address
  shell: dig +short {{ old_server }}
  changed_when: false
  register: old_server_ip
```
3. Выполните
```
terraform init
terraform apply
ansible-playbook move_outline.yml --extra-vars "new_server_ip=$(terraform output -raw new_server_ip)"
```

После выполнения верните значения в первоначальный вид. При последующем использовании просто выполняйте 3 этап.

### II. При отсутствии сервера outline

1. Выполните
```
terraform init
terraform apply
ansible-playbook new_move_outline.yml --extra-vars "new_server_ip=$(terraform output -raw new_server_ip)"
```

В дальнейшем используйте `move_outline.yml` для переноса сервера.

Имейте ввиду, скрипт не удаляет старый сервер outline! Вам необходимо делать это самостоятельно после выполнения задачи.

## Повторное использование:

1. Удалите файл `.tfstate`
2. Выполните `terraform apply`

   **ВНИМАНИЕ:** Необходимо изменить имя сервера в `new_move_outline.tf`
3. Выполните
```
ansible-playbook move_outline.yml --extra-vars "new_server_ip=$(terraform output -raw new_server_ip)"
```

4. Получите вывод после выполнения и добавьте в Outline Manager. Убедитесь в корректном переносе.
5. Зайдите в консоль hetzner и удалите старый сервер

## Что работает не так и требует улучшения:

- Добавить переиспользование. Terraform должен создавать новый сервер и удалять старый после подтверждения.
- Отказаться от `new_move_outline.yml`, добавив оператор if

