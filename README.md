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

3. Give user `postgres` full permissions to `/posts` directory with

`sudo chmod -R postgres:postgres /posts`

4. Create your locations database owned by `postgres` user

`createdb --encoding utf8 --password --owner postgres DATABASE_NAME`

Option `--password` will prompt you to enter password for the Db.

5. Use `psql DATABASE_NAME` to enter into the database.

6. Extract everything

  - Create Tables `\i tables_creation.sql` 

  - Copy regions information to `general table` with `\i general.sql` (Don't judge the repetition)

  - Extract countries `\i countries.sql` 

  - Extract all Tanzania locations `\i extract.sql`


7. Done!


### Room for improvements

1. Locations (Region, District & Wards) need to use a different auto-incrementing ID field and not it's area code.

The area code should stay as is (in it's field), but there should be
a different ID field this will help reduce mixing the IDs once we get broader
than just one country.

2. This whole process can easily be automated.

3. At least we should start with `general.sql` as I'm really not proud of it.

4. API for this will be awesome!

### Reference

This data was obtained from [TCRA POSTCODE
LIST](https://www.tcra.go.tz/index.php/publication-and-statistics/postcode-list)
we are by no means fully responsible for it's accuracy.


### Credits

Process of data standardization was the most complicated and I was helped by
a few friends whom I promised to credit.

1. Natali Isuja

2. Joe Master

3. Robert Mnama

4. And of course [TCRA](https://tcra.go.tz) for publishing this information.
