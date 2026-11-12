\# Итоговое домашнее задание по дисциплине "Программная инженерия"



Мини-инфраструктура для мониторинга API-сервиса:

Bash-скрипты, Docker Compose (nginx + http-echo), CI на GitHub Actions.



\### Структура

\- `check\_api.sh` — проверка доступности API

\- `analyze\_logs.sh` — генерация и анализ access.log

\- `docker-compose.yml` — стек api (http-echo) + proxy (nginx)

\- `.github/workflows/ci.yml` — CI-пайплайн



\### Скрипты

```

chmod +x check\_api.sh analyze\_logs.sh

./check\_api.sh https://httpbin.org/status/200   # API доступен

./check\_api.sh https://httpbin.org/status/500   # API недоступен, код ответа: 500

./analyze\_logs.sh                               # анализ access.log

```



\### Docker 

```

docker compose up -d

curl http://localhost:80   # Succesfull Monitoring Service Active

docker compose ps

docker compose down

```



\# \*\*Этап 6. SSH и SCP — безопасный деплой на удалённый сервер\*\*



1\. Создание ключа

```bash

ssh-keygen -t ed25519 -C "devops@netology" -f \~/.ssh/id\_ed25519

```

2\. Отправить публичный ключ на сервер к которому будем подключатся

```bash

ssh-copy-id -i \~/.ssh/id\_ed25519.pub user@host

```

3\. Создать архив

```bash

tar czf ../infra-monitoring-project.tar.gz \\

&#x20;   --exclude='.git' \\

&#x20;   --exclude='\*.log' \\

&#x20;   --exclude='\*.pcapng' \\

&#x20;   .

```

4\. Отправить архив проекта через scp на хост для деплоя

```bash

scp ../infra-monitoring-project.tar.gz user@host:/opt/

```

5\. Зайти на хост и для деплоя распаковать архив с проектом

```bash

ssh user@host

cd /opt

tar xzf infra-monitoring-project.tar.gz

```

6. На хосте запустить проект

```bash

cd infra-monitoring-project

docker compose up -d

```

7\. Для проверки:

```bash

curl http://127.0.0.1:80

```

