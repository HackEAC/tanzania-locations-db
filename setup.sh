#!/bin/bash

DB_NAME="locations"
DB_USER="postgres"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/location-files"

echo "🌍 Setting up Tanzania Locations DB..."

# Create database if not exists
createdb --encoding UTF8 --owner "$DB_USER" "$DB_NAME"

# Run table schema creation (make sure it defines the `general` table)
psql -U "$DB_USER" -d "$DB_NAME" -f tables_creation.sql

# Run counties query to get list of all countries
psql -U "$DB_USER" -d "$DB_NAME" -f countries.sql

# Import CSVs into the `general` table
echo "📄 Importing CSVs into the database ..."

for csv_file in "$DATA_DIR"/*.csv; do
  region_file=$(basename "$csv_file")
  echo "  ➕ Importing $region_file..."
  psql -U "$DB_USER" -d "$DB_NAME" -c "\copy general (region, regioncode, district, districtcode, ward, wardcode, street, places) FROM '$csv_file' DELIMITER ',' CSV HEADER"
done

# Update foreign key
echo "🛠 Updating country_id..."
psql -U "$DB_USER" -d "$DB_NAME" -c "UPDATE general SET country_id = 210;"

# Run extract logic
echo "🧠 Running extract logic..."
psql -P pager=off -U "$DB_USER" -d "$DB_NAME" -f extract.sql

echo "✅ All done!"
