--- Create a function to save data in every table
--- Select distinct data together with it's 
--- save in save regions func

CREATE OR REPLACE FUNCTION save_regions(r_code int, r_name text, country int, general int ) RETURNS void AS $$
    BEGIN
        EXECUTE
            '
                INSERT INTO regions(region_code, region_name, country_id, general_locations_id) VALUES($1, $2, $3, $4)
                ON CONFLICT (region_code) DO NOTHING
            '
        USING r_code, r_name, country, general;
    END;
$$ LANGUAGE plpgsql;

WITH 
  distinct_regions AS (
    SELECT DISTINCT(region), country_id, regioncode, id FROM general
),
  regions_save AS (
    SELECT save_regions(
      F.regioncode,
      F.region,
      F.country_id,
      F.id
    )
    FROM distinct_regions AS F
)

SELECT * FROM regions_save;

CREATE OR REPLACE FUNCTION save_districts(d_code int, d_name text, region int, country int, general int) RETURNS void AS $$
    BEGIN
        EXECUTE
            '
                INSERT INTO districts(district_code, district_name, region_id, country_id, general_locations_id) VALUES($1, $2, $3, $4, $5)
                ON CONFLICT (district_code) DO NOTHING
            '
        USING d_code, d_name, region, country, general;
    END;
$$ LANGUAGE plpgsql;

WITH 
  distinct_districts AS (
    SELECT DISTINCT(district), districtcode, country_id, regioncode, id FROM general
),
  district_save AS (
    SELECT save_districts(
      U.districtcode,
      U.district,
      U.regioncode,
      U.country_id,
      U.id
    ) FROM distinct_districts AS U
)

SELECT * FROM district_save;

CREATE OR REPLACE FUNCTION save_wards(w_code int, w_name text, district int, region int, country int, general int) RETURNS void AS $$
    BEGIN
        EXECUTE
            '
                INSERT INTO wards(ward_code, ward_name, district_id, region_id, country_id, general_locations_id) VALUES($1, $2, $3, $4, $5, $6)
                ON CONFLICT (ward_code) DO NOTHING
            '
        USING w_code, w_name, district, region, country, general;
    END;
$$ LANGUAGE plpgsql;

WITH 
  distinct_wards AS (
    SELECT DISTINCT(ward), wardcode, regioncode, districtcode, country_id, id
    FROM general
),
  ward_save AS (
    SELECT save_wards(
      C.wardcode,
      C.ward,
      C.districtcode,
      C.regioncode,
      C.country_id,
      C.id
    ) 
    FROM distinct_wards AS C
)

SELECT * FROM ward_save;
  
CREATE OR REPLACE FUNCTION save_places(place text, ward int, district int, region int, country int, general int) RETURNS void AS $$
    BEGIN
        EXECUTE
            '
                INSERT INTO places(
                  place_name,
                  ward_id,
                  district_id,
                  region_id,
                  country_id,
                  general_locations_id
                ) VALUES($1, $2, $3, $4, $5, $6)
            '
        USING place, ward, district, region, country, general;
    END;
$$ LANGUAGE plpgsql;

WITH 
  distinct_streets AS (
    SELECT 
      DISTINCT(wardcode), 
      street,
      regioncode,
      districtcode,
      country_id,
      id
    FROM general
),
  places_save_streets AS (
    SELECT save_places(
      K.street,
      K.wardcode,
      K.districtcode,
      K.regioncode,
      K.country_id,
      K.id
    ) FROM distinct_streets AS K
    WHERE street IS NOT NULL
)

SELECT * FROM places_save_streets;

WITH
  distinct_places AS (
    SELECT 
      DISTINCT(wardcode), 
      places,
      regioncode,
      districtcode,
      country_id,
      id
    FROM general
),
  places_save_places AS (
    SELECT save_places(
      R.places,
      R.wardcode,
      R.districtcode,
      R.regioncode,
      R.country_id,
      R.id
    ) FROM distinct_places AS R
    WHERE places IS NOT NULL
)

SELECT * FROM places_save_places;
