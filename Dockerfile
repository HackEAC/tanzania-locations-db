FROM postgres:17.4

RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

WORKDIR /sql_scripts
COPY sql-scripts/ .

WORKDIR /location_files
COPY location-files .

COPY setup.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/setup.sh
