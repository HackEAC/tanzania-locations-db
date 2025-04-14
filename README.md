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

- Close PL/PgSQL prompts with `:q` whenever prompted, this will happen in the last phrase of data extraction, which you
  will need to close the prompt for it to continue eg. "save_regions" etc..

3. This will create a database called locations that will have user postgres and have all the data.

4. You can check the data with `psql -U postgres -d locations` and run queries like `SELECT * FROM regions;` to verify
   the data.

## For Docker

1. Copy the env.example to .env and edit to match whatever values you want to use.
2. Run `docker-compose build` and `docker-compose up -d`. Or simply `docker-compose up`.


### Credits

Process of data standardization was the most complicated and I was helped by a few friends whom I promised to credit.

1. Natali Isuja
2. Joe Master
3. Robert Mnama
4. [Ano Rebel](https://github.com/AnoRebel/)
5. [Zacharia23](https://github.com/Zacharia23)
