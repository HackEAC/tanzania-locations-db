# Tanzania Locations Repo

## Quick Introduction

Tanzania locations, All Regions from Tanzania, with their respective Districts
 wards & streets.

Very useful for easily implementing Tanzania locations in any application.

### How to use

What you need before running the code.

1. Install & Start Postgresql Db Service

2. Copy files from location-files to a top level directory `/posts/...`
this is necessary for postgresql `Copy` command to function as expected [refer to this question](https://stackoverflow.com/a/48881550/2405689).

3. Give user `postgres` ownership to `/posts` directory with

`sudo chown -R postgres:postgres /posts`

4. Create your locations database owned by `postgres` user

`createdb --encoding utf8 --owner postgres DATABASE_NAME`

5. Use `psql DATABASE_NAME` to enter into the database.

6. Extract everything

  - Create Tables `\i tables_creation.sql`
  
  - Extract countries `\i countries.sql` 

  - Copy regions information to `general table` with `\i general.sql` (Don't judge the repetition)

  - Extract all Tanzania locations `\i extract.sql`

7. Done!


### Room for improvements
- [ ] Create custom IDs to reference tables in (Regions, Districts & Wards) Status: 🗓 🔥

- [ ] This whole process can easily be automated. Status: 🤔

**Current Ideas**
  - Write a Bash script to automate this  
  - Contenarization as suggested in [this issue by Olomi](https://github.com/HackEAC/tanzania-locations-db/issues/2)

- [x] API for this will be awesome. Status: 🕶
  - [Mtaa - Python Package](https://github.com/Kalebu/mtaa) 😎
  - [Mtaa API - Python API](https://github.com/HackEAC/mtaaAPI/) based on Mtaa 😎
  - [Locations API - NestJs & Postgresql](https://github.com/HackEAC/locations-API) based on this rep☻


### Credits

Process of data standardization was the most complicated and I was helped by
a few friends whom I promised to credit.

1. Natali Isuja

2. Joe Master

3. Robert Mnama
