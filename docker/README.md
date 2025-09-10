# Docker образы для geo-app

## Dockerfile-Py

• **Назначение**: Автономный FastAPI сервис без баз данных
• **Зависимости**: Только fastapi, uvicorn, prometheus-client
• **Применение**: Развертывание микросервисов, тестирование или когда базы данных внешние
• **Размер**: Меньший (150MB)

## Сборка образа

```bash
# Перейти в корневую папку проекта
cd ./geo-app/docker

# Собрать образ
docker build -f Dockerfile-Py -t geo-app-py:v1 .

# Проверить размер образа
docker images geo-app-py:v1
```

## Запуск контейнера

```bash
# Запустить контейнер
docker run -d -p 8001:8000 --name geo-app-py geo-app-py:v1

# Проверить работу
curl http://localhost:8001/ping
curl http://localhost:8001/metrics
```

## Остановка и удаление

```bash
# Остановить контейнер
docker stop geo-app-py

# Удалить контейнер
docker rm geo-app-py

# Удалить образ
docker rmi geo-app-py:v1
```
