from fastapi import FastAPI
from fastapi.responses import PlainTextResponse
import redis
import asyncpg
import time
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import os

app = FastAPI()

# Prometheus metrics
REQUEST_COUNT = Counter('requests_total', 'Total requests', ['method', 'endpoint'])
REQUEST_LATENCY = Histogram('request_duration_seconds', 'Request latency')

# Redis connection
redis_client = redis.Redis(host=os.getenv('REDIS_HOST', 'redis'), port=6379, decode_responses=True)

@app.get("/ping")
async def ping():
    start_time = time.time()
    REQUEST_COUNT.labels(method='GET', endpoint='/ping').inc()
    
    try:
        # Test Redis
        redis_client.ping()
        
        # Test PostgreSQL
        conn = await asyncpg.connect(
            host=os.getenv('POSTGRES_HOST', 'postgres'),
            port=5432,
            user=os.getenv('POSTGRES_USER', 'user'),
            password=os.getenv('POSTGRES_PASSWORD', 'password'),
            database=os.getenv('POSTGRES_DB', 'testdb')
        )
        await conn.execute('SELECT 1')
        await conn.close()
        
        REQUEST_LATENCY.observe(time.time() - start_time)
        return {"status": "ok", "message": "pong"}
    except Exception as e:
        REQUEST_LATENCY.observe(time.time() - start_time)
        return {"status": "error", "message": str(e)}

@app.get("/metrics")
async def metrics():
    return PlainTextResponse(generate_latest(), media_type=CONTENT_TYPE_LATEST)
