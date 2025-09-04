#!/bin/bash

echo "=== Service Metrics Monitor ==="
echo "Endpoint: http://localhost:8001/metrics"
echo

# Extract key metrics
METRICS=$(curl -s http://localhost:8001/metrics)

# Total requests
TOTAL_REQUESTS=$(echo "$METRICS" | grep 'requests_total{endpoint="/ping"' | awk '{print $2}')
echo "Total Requests: $TOTAL_REQUESTS"

# Request duration
DURATION_COUNT=$(echo "$METRICS" | grep 'request_duration_seconds_count' | awk '{print $2}')
DURATION_SUM=$(echo "$METRICS" | grep 'request_duration_seconds_sum' | awk '{print $2}')

if [ ! -z "$DURATION_COUNT" ] && [ ! -z "$DURATION_SUM" ] && [ "$DURATION_COUNT" != "0" ]; then
    AVG_DURATION=$(echo "scale=3; $DURATION_SUM / $DURATION_COUNT * 1000" | bc -l)
    echo "Average Response Time: ${AVG_DURATION}ms"
fi

# RPS calculation (rough estimate based on process uptime)
PROCESS_START=$(echo "$METRICS" | grep 'process_start_time_seconds' | awk '{print $2}')
CURRENT_TIME=$(date +%s)
if [ ! -z "$PROCESS_START" ] && [ ! -z "$TOTAL_REQUESTS" ]; then
    UPTIME=$(echo "$CURRENT_TIME - $PROCESS_START" | bc -l)
    RPS=$(echo "scale=2; $TOTAL_REQUESTS / $UPTIME" | bc -l)
    echo "Requests per Second: $RPS"
fi

echo
echo "Full metrics available at: http://localhost:8001/metrics"
