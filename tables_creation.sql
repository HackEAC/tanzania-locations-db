-- Clean up

DROP TABLE places;
DROP TABLE wards;
DROP TABLE districts;
DROP TABLE regions;

-- Create Tables

CREATE TABLE regions (
  region_name text,
  region_code integer NOT NULL,
  watcher_count integer,
  view_count integer,
  properties_count integer,
  country_id integer REFERENCES countries (id),
  PRIMARY KEY(region_code)
);

CREATE TABLE districts (
  district_name text,
  district_code integer NOT NULL,
  watcher_count integer,
  view_count integer,
  properties_count integer,
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
  PRIMARY KEY(ward_code)
);

CREATE TABLE places (
  id SERIAL PRIMARY KEY,
  place_name text,
  ward_id integer REFERENCES wards (ward_code),
  district_id integer REFERENCES districts (district_code),
  region_id integer REFERENCES regions (region_code),
  country integer REFERENCES countries (id)
);
