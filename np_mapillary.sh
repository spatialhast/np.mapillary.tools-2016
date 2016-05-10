#!/bin/bash
# Scripts of processing data for http://spatialhast.github.io/np.mapillary-2016/ web map

# Place folder np.mapillary in home catalog (Ubuntu). For run use commands:
# cd ~/np.mapillary.tools-2016
# ./np_mapillary.sh

HOME=~/np.mapillary.tools-2016

#database settings
HOST=localhost
PORT=5432
DBNAME=mapillary
USER=
PASSWORD=

# download_gpx_from_sequences.py settings
#BBOX='49.855693 50.114207 36.072235 36.479416' #Kharkov
BBOX='44.28 52.43 40.34 21.97' #Ukraine
MAXRESULTS=999999

# 32 users
# Get list users in Ukraine: 
# Get JSON data from "total" key https://a.mapillary.com/v2/stats/toplist?client_id=WTlZaVBSWmxRX3dQODVTN2gxWVdGUTpkMjliZGQwZWI2MTgyMjk0&cname=ukraine&limit=100
# Convert JSON to CSV http://konklone.io/json/

# 2015: for username in alex7 algot alkarol andygol b108 baditaflorin cartolab cut dmbreaker durko_freemap edjone ghostishev gwin hast ikovaltaras imsamurai ivic4u jan_mapper maxim75 older prudenko sanjak serge serhijdubyk severyndubyk urbalazs velmyshanovnyi vsviridov wiktorn yamaxim yevgeniy8 zvid

for username in hast velmyshanovnyi severyndubyk ivic4u serhijdubyk imsamurai older ghostishev ikovaltaras serge maxim75 b108 sanjak wiktorn cartolab durko_freemap zvid prudenko alexkolodko artem andygol alkarol baditaflorin algot dmbreaker vsviridov a_biatov openihatebot approksimator yurets_zil cut rekrutacja alex7 yevgeniy8 jan_mapper edjone neogame urbalazs yamaxim gwin

# zibi-osm z-yurets // update

#for username in andygol
do
	MAPILLARYUSER=$username
	
	echo -e "\e[32mHello "$MAPILLARYUSER"!\e[0m"

	# initialize folders
	rm -R _gpx
	rm -R _merge_gpx
	mkdir _merge_gpx

	echo -e "\e[32m"$MAPILLARYUSER", I'm start download your GPS traces\e[0m"
	python mapillary_tools/download_gpx_from_sequences.py -r ${BBOX} -m ${MAXRESULTS} -u ${MAPILLARYUSER}

	echo -e "\e[32m"$MAPILLARYUSER", I'm start union your GPS traces\e[0m"	
	python mapillary_tools/join_gpx_mapillary_files.py _gpx _merge_gpx/${MAPILLARYUSER}.gpx

	echo -e "\e[32m"$MAPILLARYUSER", I'm start import your GPS traces in database\e[0m"
	ogr2ogr -overwrite -s_srs "+init=epsg:4326" -t_srs "+init=epsg:4326" -f "PostgreSQL" PG:"host=$HOST user=$USER dbname=$DBNAME password=$PASSWORD" _merge_gpx/${MAPILLARYUSER}.gpx -nln gpx_user_${MAPILLARYUSER}

	psql -h $HOST -p $PORT -d $DBNAME -U $USER -c "ALTER TABLE gpx_user_${MAPILLARYUSER} DROP COLUMN track_fid,DROP COLUMN track_seg_id, 
		DROP COLUMN track_seg_point_id, DROP COLUMN ele, DROP COLUMN magvar, DROP COLUMN geoidheight, DROP COLUMN cmt, DROP COLUMN src, 
		DROP COLUMN link1_href, DROP COLUMN link1_text, DROP COLUMN link1_type, DROP COLUMN link2_href, DROP COLUMN link2_text,
		DROP COLUMN link2_type, DROP COLUMN sym, DROP COLUMN type, DROP COLUMN fix, DROP COLUMN sat, DROP COLUMN hdop, DROP COLUMN vdop,
		DROP COLUMN pdop, DROP COLUMN ageofdgpsdata, DROP COLUMN dgpsid;"
	  
	psql -h $HOST -p $PORT -d $DBNAME -U $USER -c "UPDATE gpx_user_${MAPILLARYUSER} SET name = '${MAPILLARYUSER}'"

	echo ""
done

# download ukraine-latest.osm.pbf from http://download.geofabrik.de site
#wget -O ${HOME}/osmpa/osmdata/ukraine-latest.osm.pbf "http://download.geofabrik.de/europe/ukraine-latest.osm.pbf" ${HOME}/osmpa/osmdata

# import OpenStreetMap nature_conservation_polygon features in database | 10.11.2015 - 2m40s for Ukraine | using imposm3 by olehz
#osmpa/imposm_olehz/imposm3 import -read osmpa/osmdata/ukraine-latest.osm.pbf -write -cachedir osmpa/cache -connection "postgis://$USER:$PASSWORD@$HOST:5432/$DBNAME?sslmode=disable&prefix=NONE" -dbschema-import public -mapping osmpa/mapping.json -diff -srid 4326 -overwritecache

# export nature_conservation_polygon features to GeoJSON file with simplify 
#| 10.11.2015 - 1158 features for Ukraine
#| 10.05.2016 - 1414 features for Ukraine
rm -R data/nature_conservation_polygon.geojson
ogr2ogr -nlt POLYGON -f "GeoJSON" data/nature_conservation_polygon.geojson PG:"host=$HOST user=$USER dbname=$DBNAME password=$PASSWORD" nature_conservation_polygon -simplify 0.001 -lco COORDINATE_PRECISION=5

# get statistics
#psql -h $HOST -p $PORT -d $DBNAME -U $USER -f psql_query.sql












