# Service-Py REST API

Минимальный FastAPI сервис с PostgreSQL, Redis и Prometheus метриками.

## Запуск

```bash
docker compose up --build -d
```

## Эндпоинты

- `GET /ping` - проверка работоспособности (http://localhost:8001/ping)
- `GET /metrics` - Prometheus метрики (http://localhost:8001/metrics)

## Нагрузочное тестирование

```bash
# Установка инструментов (Ubuntu/Debian)
sudo apt-get install apache2-utils

# Запуск тестов
./load_test.sh
```

## Мониторинг метрик

```bash
# Просмотр ключевых метрик
./monitor.sh
```

## Результаты тестирования

Apache Bench (1000 запросов, 10 параллельных):
- **RPS**: 38.08 запросов/сек
- **Средняя задержка**: 262.584 мс
- **95-й процентиль**: 310 мс
- **Ошибки**: 0

## Метрики Prometheus

- `requests_total` - общее количество запросов
- `request_duration_seconds` - время ответа (гистограмма)

Доступны по адресу: http://localhost:8001/metrics

## Порты

- Приложение: 8001
- PostgreSQL: 5433
- Redis: 6380
