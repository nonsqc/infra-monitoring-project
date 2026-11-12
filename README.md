# Итоговое домашнее задание по дисциплине "Программная инженерия"

Мини-инфраструктура для мониторинга API-сервиса:
Bash-скрипты, Docker Compose (nginx + http-echo), CI на GitHub Actions.
### Структура

- `check\_api.sh` — проверка доступности API

- `analyze\_logs.sh` — генерация и анализ access.log

- `docker-compose.yml` — стек api (http-echo) + proxy (nginx)

- `.github/workflows/ci.yml` — CI-пайплайн
### Скрипты

```
chmod +x check\_api.sh analyze\_logs.sh
./check\_api.sh https://httpbin.org/status/200   # API доступен
./check\_api.sh https://httpbin.org/status/500   # API недоступен, код ответа: 500
./analyze\_logs.sh                               # анализ access.log
```
### Docker 

```
docker compose up -d
curl http://localhost:80   # Succesfull Monitoring Service Active
docker compose ps
docker compose down
```

---

# **Этап 6. SSH и SCP — безопасный деплой на удалённый сервер**

1. Создание SSH-ключа

```bash
ssh-keygen -t ed25519 -C "devops@netology" -f ~/.ssh/id_ed25519
```

2. Отправка публичного ключа на сервер

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@host
```

3. Создание архива проекта

```bash
tar czf ../infra-monitoring-project.tar.gz \
    --exclude='.git' \
    --exclude='*.log' \
    --exclude='*.pcapng' \
    .
```

4. Отправка архива через `scp` на хост

```bash
scp ../infra-monitoring-project.tar.gz user@host:/opt/
```

5. Подключение к хосту и распаковка архива

```bash
ssh user@host
cd /opt
tar xzf infra-monitoring-project.tar.gz
```

6. Запуск проекта на хосте

```bash
cd infra-monitoring-project
docker compose up -d
```

7. Проверка работы

```bash
curl http://127.0.0.1:80
```

