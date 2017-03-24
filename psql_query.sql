--UNION ALL IMPORTED 'gpx_user_%USERNAME%' TABLES IN 'union_gpx_data' TABLE
SELECT maskunion('public', 'gpx_user_', 'union_gpx_data');
--
--
--'union_gpx_data': RENAME 'ogc_fid', 'wkb_geometry', 'time' FIELDS. DELETE 'desc' FIELD. CHANGE DATA TYPE FOR 'gpxtime' FIELD
ALTER TABLE "union_gpx_data" RENAME ogc_fid TO id; 
ALTER TABLE "union_gpx_data" RENAME wkb_geometry TO geom; 
ALTER TABLE "union_gpx_data" RENAME "time" TO gpxtime;
ALTER TABLE "union_gpx_data" DROP COLUMN "desc";
ALTER TABLE "union_gpx_data" ALTER COLUMN gpxtime TYPE date USING gpxtime::date;
--
--
--delete features outside Ukraine
DELETE FROM nature_conservation_polygon WHERE CAST(osm_id AS TEXT) LIKE '%423715481' OR CAST(osm_id AS TEXT) LIKE '%423719522' OR CAST(osm_id AS TEXT) LIKE '%423712513' OR CAST(osm_id AS TEXT) LIKE '%423723155' OR CAST(osm_id AS TEXT) LIKE '%423723127' OR CAST(osm_id AS TEXT) LIKE '%423722980' OR CAST(osm_id AS TEXT) LIKE '%6297592' OR CAST(osm_id AS TEXT) LIKE '%423723170' OR CAST(osm_id AS TEXT) LIKE '%6297573' OR CAST(osm_id AS TEXT) LIKE '%420095633' OR CAST(osm_id AS TEXT) LIKE '%420095638' OR CAST(osm_id AS TEXT) LIKE '%420095648' OR CAST(osm_id AS TEXT) LIKE '%420095632' OR CAST(osm_id AS TEXT) LIKE '%80897380' OR CAST(osm_id AS TEXT) LIKE '%80897446' OR CAST(osm_id AS TEXT) LIKE '%6449177' OR CAST(osm_id AS TEXT) LIKE '%39398403' OR CAST(osm_id AS TEXT) LIKE '%6297896' OR CAST(osm_id AS TEXT) LIKE '%6297217' OR CAST(osm_id AS TEXT) LIKE '%6297212' OR CAST(osm_id AS TEXT) LIKE '%6297184' OR CAST(osm_id AS TEXT) LIKE '%4524665' OR CAST(osm_id AS TEXT) LIKE '%6297172' OR CAST(osm_id AS TEXT) LIKE '%423719348' OR CAST(osm_id AS TEXT) LIKE '%4522170' OR CAST(osm_id AS TEXT) LIKE '%6297210' OR CAST(osm_id AS TEXT) LIKE '%4522409' OR CAST(osm_id AS TEXT) LIKE '%4767653' OR CAST(osm_id AS TEXT) LIKE '%253459229' OR CAST(osm_id AS TEXT) LIKE '%88130706' OR CAST(osm_id AS TEXT) LIKE '%135249990' OR CAST(osm_id AS TEXT) LIKE '%98829074' OR CAST(osm_id AS TEXT) LIKE '%98829071' OR CAST(osm_id AS TEXT) LIKE '%81004197' OR CAST(osm_id AS TEXT) LIKE '%80897468' OR CAST(osm_id AS TEXT) LIKE '%80897472' OR CAST(osm_id AS TEXT) LIKE '%80897284' OR CAST(osm_id AS TEXT) LIKE '%6297577' OR CAST(osm_id AS TEXT) LIKE '%423723169' OR CAST(osm_id AS TEXT) LIKE '%423723193' OR CAST(osm_id AS TEXT) LIKE '%423723141' OR CAST(osm_id AS TEXT) LIKE '%423723194' OR CAST(osm_id AS TEXT) LIKE '%6297207' OR CAST(osm_id AS TEXT) LIKE '%6297191' OR CAST(osm_id AS TEXT) LIKE '%423711769' OR CAST(osm_id AS TEXT) LIKE '%423711700' OR CAST(osm_id AS TEXT) LIKE '%6297190' OR CAST(osm_id AS TEXT) LIKE '%423711737' OR CAST(osm_id AS TEXT) LIKE '%4522119' OR CAST(osm_id AS TEXT) LIKE '%3397849' OR CAST(osm_id AS TEXT) LIKE '%423711758' OR CAST(osm_id AS TEXT) LIKE '%80898826' OR CAST(osm_id AS TEXT) LIKE '%80898112';

-- CREATE 'ncp_buffer' TABLE WITH 20m GEOM BUFFER FROM 'nature_conservation_polygon' TABLE
DROP TABLE IF EXISTS ncp_buffer;
CREATE TABLE ncp_buffer AS SELECT a.name, a.boundary, ST_Buffer( ST_Transform(a.geom, utmzone(ST_Centroid(a.geom))), 40) AS geom FROM nature_conservation_polygon a;
ALTER TABLE ncp_buffer ALTER COLUMN geom TYPE Geometry(Geometry,4326) USING ST_Transform(geom,4326);
--
--
--CREATE 'data_first_time' TABLE WITH 'gpxtime' BETWEEN '2016-01-01 - 2016-12-18'
DROP TABLE IF EXISTS data_first_time;
CREATE TABLE data_first_time AS SELECT * FROM union_gpx_data WHERE gpxtime BETWEEN '2016-01-01 00:00:00'::timestamp AND '2016-12-18 23:59:59'::timestamp ORDER BY id DESC;
--
--CREATE 'data_first_in_np' WITH POINTS IN NP 
DROP TABLE IF EXISTS data_first_in_np;
CREATE TABLE data_first_in_np AS SELECT a.* FROM data_first_time a, ncp_buffer b WHERE ST_Intersects(a.geom, b.geom);
--
--ADD NP NAMES TO POINTS
ALTER TABLE data_first_in_np ADD COLUMN paname character varying; 
UPDATE data_first_in_np points SET paname = p.name 
FROM ncp_buffer p WHERE ST_Contains(p.geom, points.geom);
--
--CREATE TABLE WITH STATISTICS
DROP TABLE IF EXISTS table_count_first;
CREATE TABLE table_count_first AS SELECT name, paname, COUNT(*) FROM data_first_in_np GROUP BY name, paname ORDER BY count;
--
--CREATE JSON DATA
COPY (SELECT array_to_json(array_agg(row_to_json(t))) FROM (SELECT  name, array_agg(paname) AS paname, SUM(count) AS count FROM table_count_first GROUP BY name ORDER BY count DESC) t) to '/home/hast/np.mapillary.tools-2016/data/mapillary_data.json';
--COPY (SELECT array_to_json(array_agg(row_to_json(t))) FROM (SELECT  name, array_agg(paname) AS paname, SUM(count) AS count FROM table_count_first GROUP BY name ORDER BY count DESC) t) to 'D:\np.mapillary.tools-2016\data\mapillary_data.json';
--
--
--
SELECT footgun('public', 'gpx_user_');


/*
CREATE OR REPLACE FUNCTION maskunion(IN _schema TEXT, IN _parttionbase TEXT, TEXT)
RETURNS void
LANGUAGE plpgsql
AS
$$
DECLARE
    row     record;
BEGIN
    EXECUTE 'DROP TABLE IF EXISTS ' || $3;
    EXECUTE 'CREATE TABLE ' || $3 || '
        (
          ogc_fid integer,
          "time" timestamp with time zone,
          name character varying,
          "desc" character varying,
          wkb_geometry geometry(Point,4326)
        )';
    FOR row IN
        SELECT
            table_schema,
            table_name
        FROM
            information_schema.tables
        WHERE
            table_type = 'BASE TABLE'
        AND
            table_schema = _schema
        AND
            table_name ILIKE (_parttionbase || '%')
    LOOP
        EXECUTE 'INSERT INTO ' || $3 || ' SELECT * FROM ' || quote_ident(row.table_name);
    END LOOP;
END;
$$;

--SELECT maskunion('public', 'gpx_user_', 'union_gpx_data');
*/


/*
CREATE OR REPLACE FUNCTION footgun(IN _schema TEXT, IN _parttionbase TEXT)
RETURNS void
LANGUAGE plpgsql
AS
$$
DECLARE
    row     record;
BEGIN
    FOR row IN
        SELECT
            table_schema,
            table_name
        FROM
            information_schema.tables
        WHERE
            table_type = 'BASE TABLE'
        AND
            table_schema = _schema
        AND
            table_name ILIKE (_parttionbase || '%')
    LOOP
        EXECUTE 'DROP TABLE ' || quote_ident(row.table_schema) || '.' || quote_ident(row.table_name);
        RAISE INFO 'Dropped table: %', quote_ident(row.table_schema) || '.' || quote_ident(row.table_name);
    END LOOP;
END;
$$;
 
--SELECT footgun('public', 'gpx_user_');
*/


/*
CREATE OR REPLACE FUNCTION utmzone(geometry)
   RETURNS integer AS
 $BODY$
 DECLARE
     geomgeog geometry;
     zone int;
     pref int;

 BEGIN
     geomgeog:= ST_Transform($1,4326);

     IF (ST_Y(geomgeog))>0 THEN
        pref:=32600;
     ELSE
        pref:=32700;
     END IF;

     zone:=floor((ST_X(geomgeog)+180)/6)+1;

     RETURN zone+pref;
 END;
 $BODY$ LANGUAGE 'plpgsql' IMMUTABLE
   COST 100;
*/