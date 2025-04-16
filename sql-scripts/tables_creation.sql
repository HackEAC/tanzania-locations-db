-- Clean up

DROP TABLE countries CASCADE;
DROP TABLE general CASCADE;
DROP TABLE places CASCADE;
DROP TABLE wards CASCADE;
DROP TABLE districts CASCADE;
DROP TABLE regions CASCADE;

-- Create Tables

CREATE TABLE countries (
  id SERIAL PRIMARY KEY,
  iso char(2) NOT NULL,
  name text NOT NULL,
  nicename text NOT NULL,
  iso3 char(3) DEFAULT NULL,
  numcode int DEFAULT NULL,
  phonecode int NOT NULL
);

CREATE TABLE general (
  id SERIAL PRIMARY KEY,
  country_id INT,
  region VARCHAR NOT NULL,
  regioncode INT NOT NULL,
  district VARCHAR NOT NULL,
  districtcode INT NOT NULL,
  ward VARCHAR NOT NULL,
  wardcode INT NOT NULL,
  street VARCHAR,
  places VARCHAR,

  search_vector tsvector GENERATED ALWAYS AS (
    to_tsvector(
      'simple',
      coalesce(region, '') || ' ' ||
      coalesce(district, '') || ' ' ||
      coalesce(ward, '') || ' ' ||
      coalesce(street, '') || ' ' ||
      coalesce(places, '')
    )
  ) STORED
);

CREATE TABLE regions (
  region_name text,
  region_code integer NOT NULL,
  general_locations_id integer REFERENCES general (id),
  country_id integer REFERENCES countries (id),
  PRIMARY KEY(region_code)
);

CREATE TABLE districts (
  district_name text,
  district_code integer NOT NULL,
  general_locations_id integer REFERENCES general (id),
  region_id integer REFERENCES regions (region_code),
  country_id integer REFERENCES countries (id),
  PRIMARY KEY(district_code)
);

CREATE TABLE wards (
  ward_name text,
  ward_code integer NOT NULL,
  district_id integer REFERENCES districts (district_code),
  region_id integer REFERENCES regions (region_code),
  country_id integer REFERENCES countries (id),
  general_locations_id integer REFERENCES general (id),
  PRIMARY KEY(ward_code)
);

CREATE TABLE places (
  id SERIAL PRIMARY KEY,
  place_name text,
  ward_id integer,
  district_id integer,
  region_id integer,
  country_id integer,
  general_locations_id integer REFERENCES general (id)
);

--- INDEXES

--- General 

CREATE INDEX general_search_vector_idx ON "general" USING GIN ("search_vector");

--- Countries

CREATE UNIQUE INDEX idx_countries_iso ON countries (iso);

--- Regions
CREATE INDEX idx_regions_country_id ON regions (country_id);
CREATE INDEX idx_regions_general_id ON regions (general_locations_id);

--- Districts

CREATE INDEX idx_districts_region_id ON districts (region_id);
CREATE INDEX idx_districts_country_id ON districts (country_id);
CREATE INDEX idx_districts_general_id ON districts (general_locations_id);

--- Wards

CREATE INDEX idx_wards_district_id ON wards (district_id);
CREATE INDEX idx_wards_region_id ON wards (region_id);
CREATE INDEX idx_wards_country_id ON wards (country_id);
CREATE INDEX idx_wards_general_id ON wards (general_locations_id);

--- Places

CREATE INDEX idx_places_ward_id ON places (ward_id);
CREATE INDEX idx_places_district_id ON places (district_id);
CREATE INDEX idx_places_region_id ON places (region_id);
CREATE INDEX idx_places_country_id ON places (country_id);
CREATE INDEX idx_places_general_id ON places (general_locations_id);
