-- First Populate the general table with TAnzania country_id

UPDATE general SET country_id = 210;

                    -- Then --
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
  RETURNING wards.ward_code
)

SELECT * FROM regions_insert;
