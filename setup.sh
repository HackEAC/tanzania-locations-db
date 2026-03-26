#!/bin/bash
set -euo pipefail

DB_NAME="${POSTGRES_DB:-locations}"
DB_USER="${POSTGRES_USER:-postgres}"
DB_HOST="${POSTGRES_HOST:-localhost}"
DB_PORT="${POSTGRES_PORT:-5432}"
READY_DB="${POSTGRES_READY_DB:-postgres}"

if [ -d "/location_files" ]; then
  DATA_DIR="/location_files"
else
  DATA_DIR="${DATA_DIR:-$(pwd)/location-files}"
fi

if [ -d "/sql_scripts" ]; then
  SQL_DIR="/sql_scripts"
else
  SQL_DIR="${SQL_DIR:-$(pwd)/sql-scripts}"
fi

PSQL_CMD=(psql -v ON_ERROR_STOP=1 --pset pager=off)

echo "Setting up Tanzania Locations DB..."

if [ -n "${DIRECT_URL:-}" ]; then
  echo "Using DIRECT_URL for schema changes and data import."
  PSQL_CMD+=("${DIRECT_URL}")
elif [ -n "${DATABASE_URL:-}" ]; then
  echo "Using DATABASE_URL for schema changes and data import."
  PSQL_CMD+=("${DATABASE_URL}")
else
  echo "Waiting for DB to be ready..."
  until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$READY_DB" >/dev/null 2>&1; do
    sleep 1
  done

  echo "Creating database..."
  createdb \
    -h "$DB_HOST" \
    -p "$DB_PORT" \
    -U "$DB_USER" \
    --encoding UTF8 \
    --owner "$DB_USER" \
    "$DB_NAME" || echo "Database already exists, skipping creation."

  PSQL_CMD+=(-h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME")
fi

echo "Creating tables..."
"${PSQL_CMD[@]}" -f "$SQL_DIR/tables_creation.sql"

echo "Inserting countries..."
"${PSQL_CMD[@]}" -f "$SQL_DIR/countries.sql"

echo "Importing CSVs from: $DATA_DIR"

shopt -s nullglob
CSV_FILES=("$DATA_DIR"/*.csv)
if [ ${#CSV_FILES[@]} -eq 0 ]; then
  echo "No CSV files found in $DATA_DIR"
  exit 1
fi

for csv_file in "${CSV_FILES[@]}"; do
  region_file=$(basename "$csv_file")
  absolute_csv="$(cd "$(dirname "$csv_file")" && pwd)/$(basename "$csv_file")"
  echo "  Importing $region_file..."
  "${PSQL_CMD[@]}" -c "\copy general (region, regioncode, district, districtcode, ward, wardcode, street, places) FROM '$absolute_csv' WITH (FORMAT csv, HEADER true)"
done

echo "Updating country_id..."
"${PSQL_CMD[@]}" -c "UPDATE general SET country_id = 210;"

echo "Running extract.sql..."
"${PSQL_CMD[@]}" -f "$SQL_DIR/extract.sql"

echo "Tanzania Locations DB setup complete."
