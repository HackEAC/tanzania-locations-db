#!/bin/bash
set -e

DB_NAME="${POSTGRES_DB:-locations}"
DB_USER="${POSTGRES_USER:-postgres}"

DATA_DIR="/location_files"

echo "🌍 Setting up Tanzania Locations DB..."

echo "Waiting for DB to be ready..."
until pg_isready -U "$DB_USER"; do
  sleep 1
done

echo "Creating database..."
createdb --encoding UTF8 --owner "$DB_USER" "$DB_NAME" || echo "⚠️  Database already exists, skipping creation."

echo "Creating tables..."
psql -U "$DB_USER" -d "$DB_NAME" -f /sql_scripts/tables_creation.sql

echo "Inserting countries..."
psql -U "$DB_USER" -d "$DB_NAME" -f /sql_scripts/countries.sql

echo "📄 Importing CSVs from: $DATA_DIR"

shopt -s nullglob
CSV_FILES=("$DATA_DIR"/*.csv)
if [ ${#CSV_FILES[@]} -eq 0 ]; then
  echo "❌ No CSV files found in $DATA_DIR"
  exit 1
fi

for csv_file in "${CSV_FILES[@]}"; do
  region_file=$(basename "$csv_file")
  echo "  ➕ Importing $region_file..."
  psql -U "$DB_USER" -d "$DB_NAME" -c "\copy general (region, regioncode, district, districtcode, ward, wardcode, street, places) FROM '$csv_file' WITH (FORMAT csv, HEADER true)"
done

echo "🛠 Updating country_id..."
psql -U "$DB_USER" -d "$DB_NAME" -c "UPDATE general SET country_id = 210;"

echo "🧠 Running extract.sql..."
psql -U "$DB_USER" -d "$DB_NAME" -f /sql_scripts/extract.sql

echo "✅ Tanzania Locations DB setup complete!"
