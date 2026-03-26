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
    SELECT
      regioncode,
      MIN(region) AS region,
      country_id,
      MIN(id) AS id
    FROM general
    GROUP BY regioncode, country_id
),
  regions_save AS (
    SELECT save_regions(
      r.regioncode,
      r.region,
      r.country_id,
      r.id
    )
    FROM distinct_regions AS r
)

SELECT COUNT(*) AS regions_saved FROM regions_save;

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
    SELECT
      districtcode,
      MIN(district) AS district,
      country_id,
      regioncode,
      MIN(id) AS id
    FROM general
    GROUP BY districtcode, country_id, regioncode
),
  district_save AS (
    SELECT save_districts(
      d.districtcode,
      d.district,
      d.regioncode,
      d.country_id,
      d.id
    ) FROM distinct_districts AS d
)

SELECT COUNT(*) AS districts_saved FROM district_save;

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
    SELECT
      wardcode,
      MIN(ward) AS ward,
      regioncode,
      districtcode,
      country_id,
      MIN(id) AS id
    FROM general
    GROUP BY wardcode, regioncode, districtcode, country_id
),
  ward_save AS (
    SELECT save_wards(
      w.wardcode,
      w.ward,
      w.districtcode,
      w.regioncode,
      w.country_id,
      w.id
    ) 
    FROM distinct_wards AS w
)

SELECT COUNT(*) AS wards_saved FROM ward_save;
  
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
      wardcode,
      street,
      regioncode,
      districtcode,
      country_id,
      MIN(id) AS id
    FROM general
    WHERE street IS NOT NULL
    GROUP BY wardcode, street, regioncode, districtcode, country_id
),
  distinct_places AS (
    SELECT 
      wardcode,
      places,
      regioncode,
      districtcode,
      country_id,
      MIN(id) AS id
    FROM general
    WHERE places IS NOT NULL
    GROUP BY wardcode, places, regioncode, districtcode, country_id
  ),
  combined_places AS (
    SELECT
      wardcode,
      street AS place_name,
      regioncode,
      districtcode,
      country_id,
      id
    FROM distinct_streets
    UNION ALL
    SELECT
      wardcode,
      places AS place_name,
      regioncode,
      districtcode,
      country_id,
      id
    FROM distinct_places
  ),
  distinct_place_rows AS (
    SELECT
      wardcode,
      place_name,
      regioncode,
      districtcode,
      country_id,
      MIN(id) AS id
    FROM combined_places
    GROUP BY wardcode, place_name, regioncode, districtcode, country_id
  ),
  places_save AS (
    SELECT save_places(
      p.place_name,
      p.wardcode,
      p.districtcode,
      p.regioncode,
      p.country_id,
      p.id
    ) FROM distinct_place_rows AS p
)

SELECT COUNT(*) AS places_saved FROM places_save;
