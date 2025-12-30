#!/bin/bash
set -e

echo "==> Waiting for Postgres..."
until pg_isready -h db -U postgres; do
  echo "Postgres is unavailable - sleeping"
  sleep 2
done
echo "Postgres is up!"

echo "==> Waiting for Elasticsearch..."
until curl -s http://elasticsearch:9200/_cluster/health | grep -q '"status":"yellow"'; do
  echo "Elasticsearch is unavailable - sleeping"
  sleep 5
done
echo "Elasticsearch is up!"

# Remove old server PID if exists
rm -f tmp/pids/server.pid

# Run the main container command
exec "$@"
