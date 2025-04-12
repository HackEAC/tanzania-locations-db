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
  Id SERIAL PRIMARY KEY,
  country_id int,
  REGION varchar NOT NULL,
  REGIONCODE int NOT NULL,
  DISTRICT varchar NOT NULL,
  DISTRICTCODE int NOT NULL,
  WARD varchar NOT NULL,
  WARDCODE int NOT NULL,
  STREET varchar,
  PLACES varchar
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
