# Tanzania Locations Repo

## Quick Introduction

Tanzania locations, All Regions from Tanzania, with their respective Districts wards & streets.

Very useful for easily implementing Tanzania locations in any application.

### How to use

What you need before running the code.

1. Install & Start Postgresql Db Service

2. Extract everything

- Give setup.sh execute permission with `chmod +x ./setup.sh`

- Run the setup file with `./setup.sh`

3. This will create a database called locations that will have user postgres and have all the data.

4. You can check the data with `psql -U postgres -d locations` and run queries like `SELECT * FROM regions;` to verify
   the data.

The setup script drops and recreates the project tables before importing the data, so do not run it against tables you
want to keep.

### Direct PostgreSQL Import

You can import the dataset directly into any PostgreSQL database by exporting a database connection string.

1. Export your database connection string:

```bash
export DATABASE_URL="postgresql://<user>:<password>@<host>:5432/<database>?sslmode=require"
```

2. Run the setup script from the repository root:

```bash
chmod +x ./setup.sh
./setup.sh
```

3. Verify the import:

```bash
psql "$DATABASE_URL" -c "SELECT count(*) FROM general;"
psql "$DATABASE_URL" -c "SELECT count(*) FROM regions;"
psql "$DATABASE_URL" -c "SELECT count(*) FROM districts;"
psql "$DATABASE_URL" -c "SELECT count(*) FROM wards;"
psql "$DATABASE_URL" -c "SELECT count(*) FROM places;"
```

Expected counts after a successful import:

- `regions`: 26
- `districts`: 158
- `wards`: 3945
- `general`: 68571
- `places`: 75020

## For Docker

1. Pull image
```
docker pull archnoob/tanzania-locations-db
```

2. After pulling the image, create a .env file based on the provided template:
```
cp env.example .env
```
3. Run with Docker Compose (Recommended)
```
docker-compose up -d
```
4. Or run manually (with env vars)
```
docker run -d \
  --name tanzania-locations \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_DB=locations \
  archnoob/tanzania-locations-db
```

### Credits

A few folks made this happen, from standardizing the data to creating the
database, writing the scripts and testing. Thank you all for your
contributions.

1. Natali Isuja
2. Joe Master
3. Robert Mnama
4. [Ano Rebel](https://github.com/AnoRebel/)
5. [Zacharia23](https://github.com/Zacharia23)
