#!/bin/sh
set -eu

IFS='
'

echo "Waiting for Postgres..."
until pg_isready -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" >/dev/null 2>&1; do
  sleep 2
done

ensure_role() {
  dbname="$1"
  dbuser="$2"
  dbpass="$3"

  psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d postgres -v ON_ERROR_STOP=1 <<SQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = '$dbuser') THEN
    CREATE ROLE "$dbuser" LOGIN PASSWORD '$dbpass';
  END IF;
END
\$\$;
SQL
}

ensure_db() {
  dbname="$1"
  dbuser="$2"

  exists=$(psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname = '$dbname'" || true)
  if [ "$exists" != "1" ]; then
    createdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -O "$dbuser" "$dbname"
  fi
}

echo "$POSTGRES_APP_DEFINITIONS" | while IFS='|' read -r app dbname dbuser dbpass; do
  [ -z "${app:-}" ] && continue
  ensure_role "$dbname" "$dbuser" "$dbpass"
  ensure_db "$dbname" "$dbuser"
done

echo "Postgres maintenance complete."
