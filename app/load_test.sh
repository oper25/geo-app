#!/bin/bash

echo "Starting load tests..."

# Test with ab (Apache Bench)
echo "=== Apache Bench Test ==="
ab -n 1000 -c 10 http://localhost:8001/ping

# Test with wrk (if available)
if command -v wrk &> /dev/null; then
    echo "=== wrk Test ==="
    wrk -t4 -c10 -d30s http://localhost:8001/ping
fi

# Test with hey (if available)
if command -v hey &> /dev/null; then
    echo "=== hey Test ==="
    hey -n 1000 -c 10 http://localhost:8001/ping
fi

echo "Load tests completed. Check metrics at http://localhost:8001/metrics"
