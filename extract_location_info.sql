-- Insert into regions return region_id, country_id
-- Insert into districts return district_id, region_id & country_id
-- Insert into wards return ward_id, district_id, 

WITH regions_insert AS (
  INSERT INTO regions(region_name, region_code, country_id)
  SELECT general.region, general.regioncode, general.country_id 
  FROM general
  ON CONFLICT(region_code) DO NOTHING
  RETURNING regions.region_code AS region_id
), districts_insert AS (
  INSERT INTO districts(district_code, district_name, region_id, country_id)
  SELECT general.districtcode, general.district, regions_insert.region_id, general.country_id
  FROM general,regions_insert
  ON CONFLICT(district_code) DO NOTHING
  RETURNING districts.district_code AS district_id
), wards_insert AS (
  INSERT INTO wards(ward_code, ward_name, district_id, region_id, country_id)
  SELECT general.wardcode, general.ward, districts_insert.district_id, regions_insert.region_id, general.country_id
  FROM general, districts_insert, regions_insert
  ON CONFLICT(ward_code) DO NOTHING
  RETURNING wards.ward_code AS ward_id
)

SELECT * FROM regions_insert;

--
 --places_insert_one AS (
  --INSERT INTO places(place_name, ward_id[0])
  --SELECT 
    --general.street,
    --wards_insert.ward_id
  --FROM
    --general,
    --wards_insert
  --WHERE
    --general.street IS NOT NULL
  --LIMIT 100
  --ON CONFLICT(place_name) DO UPDATE
    --SET ward_id = array_append(excluded.ward_id)
    --RETURNING *
--)


-- Only using streets not places in general db

/* , places_insert_two AS ( */
/*   INSERT INTO places(place_name, ward_id, district_id) */
/*   SELECT general.places, wards_insert.ward_id, districts_insert.district_id */
/*   FROM general, wards_insert, districts_insert */
/*   WHERE general.places IS NOT NULL */
/* /, places_insert AS ( */
/*   INSERT INTO places(place_name, ward_id, district_id) */
/*   SELECT general.street, wards_insert.ward_id, districts_insert.district_id */
/*   FROM general, wards_insert, districts_insert */
/*   WHERE general.street IS NOT NULL */
/*   RETURNING places.place_name AS streets */
/* ) */
/* *   RETURNING places.place_name AS other_streets *1/ */
/* ) */

