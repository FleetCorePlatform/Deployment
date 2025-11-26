CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE "coordinators" (
  "uuid" uuid PRIMARY KEY,
  "cognito_sub" varchar UNIQUE,
  "first_name" varchar,
  "last_name" varchar,
  "email" varchar UNIQUE,
  "registration_date" timestamp
);

CREATE TABLE "outposts" (
  "uuid" uuid UNIQUE PRIMARY KEY,
  "name" varchar,
  "latitude" decimal(9,6) NOT NULL CHECK (latitude BETWEEN -90 AND 90),
  "longitude" decimal(10,6) NOT NULL CHECK (longitude BETWEEN -180 AND 180),
  "area" geometry(Polygon, 4326) NOT NULL,
  "created_by" uuid,
  "created_at" timestamp
);

CREATE TABLE "groups" (
  "uuid" uuid UNIQUE PRIMARY KEY,
  "outpost_uuid" uuid,
  "name" varchar,
  "created_at" timestamp
);

CREATE TABLE "seat_tokens" (
  "uuid" uuid PRIMARY KEY,
  "created_by" uuid,
  "group" uuid,
  "created_at" timestamp
);

CREATE TABLE "drones" (
  "uuid" uuid UNIQUE PRIMARY KEY,
  "name" varchar,
  "group_uuid" uuid,
  "address" varchar,
  "manager_version" varchar,
  "first_discovered" timestamp,
  "home_position" geometry(PointZ)
);

CREATE TABLE "log_files" (
  "uuid" uuid UNIQUE PRIMARY KEY,
  "drone_uuid" uuid,
  "created_at" timestamp,
  "archived" boolean DEFAULT false,
  "archived_date" timestamp
);

CREATE TABLE "missions" (
  "uuid" uuid UNIQUE PRIMARY KEY,
  "group_uuid" uuid,
  "name" varchar UNIQUE,
  "bundle_url" varchar,
  "start_time" timestamp,
  "created_by" uuid
);

CREATE TABLE "drone_maintenance" (
  "uuid" uuid UNIQUE PRIMARY KEY,
  "drone_uuid" uuid,
  "performed_by" uuid,
  "maintenance_type" varchar,
  "description" text,
  "performed_at" timestamp
);

ALTER TABLE "outposts" ADD CONSTRAINT "fk_outposts_created_by" FOREIGN KEY ("created_by") REFERENCES "coordinators" ("uuid") ON DELETE SET NULL;

ALTER TABLE "groups" ADD CONSTRAINT "fk_groups_outpost" FOREIGN KEY ("outpost_uuid") REFERENCES "outposts" ("uuid") ON DELETE CASCADE;

ALTER TABLE "seat_tokens" ADD CONSTRAINT "fk_seat_tokens_group" FOREIGN KEY ("group") REFERENCES "groups" ("uuid") ON DELETE SET NULL;

ALTER TABLE "seat_tokens" ADD CONSTRAINT "fk_seat_tokens_created_by" FOREIGN KEY ("created_by") REFERENCES "coordinators" ("uuid") ON DELETE SET NULL;

ALTER TABLE "drones" ADD CONSTRAINT "fk_drones_group" FOREIGN KEY ("group_uuid") REFERENCES "groups" ("uuid") ON DELETE CASCADE;

ALTER TABLE "log_files" ADD CONSTRAINT "fk_log_files_drone" FOREIGN KEY ("drone_uuid") REFERENCES "drones" ("uuid") ON DELETE SET NULL;

ALTER TABLE "missions" ADD CONSTRAINT "fk_missions_group" FOREIGN KEY ("group_uuid") REFERENCES "groups" ("uuid") ON DELETE SET NULL;

ALTER TABLE "missions" ADD CONSTRAINT "fk_missions_created_by" FOREIGN KEY ("created_by") REFERENCES "coordinators" ("uuid") ON DELETE SET NULL;

ALTER TABLE "drone_maintenance" ADD CONSTRAINT "fk_maintenance_drone" FOREIGN KEY ("drone_uuid") REFERENCES "drones" ("uuid") ON DELETE SET NULL;

ALTER TABLE "drone_maintenance" ADD CONSTRAINT "fk_maintenance_performed_by" FOREIGN KEY ("performed_by") REFERENCES "coordinators" ("uuid") ON DELETE SET NULL;
