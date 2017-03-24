#!/bin/bash
# Scripts of processing data for http://spatialhast.github.io/np.mapillary-2016/ web map

# Place folder np.mapillary in home catalog (Ubuntu). For run use commands:
# cd ~/np.mapillary.tools-2016
# ./np_mapillary.sh
# cat np_mapillary.sh | tr -d '\r' > corrected-np_mapillary.sh

HOME=~/np.mapillary.tools-2016

# settings
        HOST=localhost
        PORT=5432
        DBNAME=
        USER=
        PGPASSWORD=
 export PGPASSWORD=

# download_gpx_from_sequences.py settings
#BBOX='49.855693 50.114207 36.072235 36.479416' #Kharkov
BBOX='44.28 52.43 40.34 21.97' #Ukraine
MAXRESULTS=999999

# 32 users
# Get list users in Ukraine: 
# Get JSON data from "total" key https://a.mapillary.com/v2/stats/toplist?client_id=WTlZaVBSWmxRX3dQODVTN2gxWVdGUTpkMjliZGQwZWI2MTgyMjk0&cname=ukraine&limit=200
# https://a.mapillary.com/v2/stats/toplist/85633805/wof?client_id=WTlZaVBSWmxRX3dQODVTN2gxWVdGUTpkMjliZGQwZWI2MTgyMjk0&limit=500


# Convert JSON to CSV http://konklone.io/json/

# 2015: for username in alex7 algot alkarol andygol b108 baditaflorin cartolab cut dmbreaker durko_freemap edjone ghostishev gwin hast ikovaltaras imsamurai ivic4u jan_mapper maxim75 older prudenko sanjak serge serhijdubyk severyndubyk urbalazs velmyshanovnyi vsviridov wiktorn yamaxim yevgeniy8 zvid

# hast velmyshanovnyi severyndubyk ivic4u serhijdubyk imsamurai older ghostishev ikovaltaras serge maxim75 b108 sanjak wiktorn cartolab durko_freemap zvid prudenko alexkolodko artem andygol alkarol baditaflorin algot dmbreaker vsviridov a_biatov openihatebot approksimator yurets_zil cut rekrutacja alex7 yevgeniy8 jan_mapper edjone neogame urbalazs yamaxim gwin z-yurets

# 20.05.2016 hast velmyshanovnyi severyndubyk serhijdubyk ivic4u imsamurai older ghostishev z-yurets ikovaltaras serge blackbird27 maxim75 b108 sanjak wiktorn cartolab durko_freemap zvid prudenko alexkolodko artem andygol alkarol baditaflorin algot dmbreaker vsviridov a_biatov openihatebot approksimator yurets_zil cut rekrutacja alex7 yevgeniy8 jan_mapper edjone neogame urbalazs yamaxim gwin onorua

# 28.05.2016 
#for username in hast velmyshanovnyi severyndubyk serhijdubyk ivic4u imsamurai older ghostishev z-yurets ikovaltaras serge blackbird27 maxim75 b108 sanjak wiktorn cartolab durko_freemap zvid prudenko alexkolodko artem andygol alkarol baditaflorin algot dmbreaker vsviridov a_biatov openihatebot approksimator yurets_zil cut rekrutacja alex7 yevgeniy8 jan_mapper edjone neogame urbalazs yamaxim gwin onorua vettellfc sergey82k yurii.repalo zakharchenko wowik filutkie neoyarik nikitakoshakov zcor yaras xx_nf_xx vatruha yumi232 camed1955 tkukovska mike140 vovenarg javnik olena virtakuono tretyakov urken91 olenas svetlulichka westbam urban4ik nemirovayulia tetianachukhno turchin kuka aleksandrb99 heleeeeeen sevar amator265 sergiokozzy gisfile olga
 
# 07.10.2016 
#for username in hast velmyshanovnyi blackbird27 severyndubyk denys serhijdubyk turchin ivic4u imsamurai older wowik approksimator roman_ty andygol tavi ghostishev tkukovska virtakuono ikovaltaras serge zakharchenko sergey82k kuka yaras filutkie maxim75 olena westbam algot b108 svetlulichka olenas mike140 sanjak tretyakov wiktorn cartolab vatruha durko_freemap r1kki aleksandrb99 zvid sergiokozzy prudenko alexkolodko dmatushe edjone urken91 javnik artem broztyto alkarol zcor dianka slandewi urban4ik baditaflorin openihatebot dmbreaker buravchenko_ek annatop vettellfc vsviridov a_biatov qivi svetlana nastya1230003 serhidotzenko akimchenko heleeeeeen nemirovayulia any sevar tetianachukhno yurets_zil cut ninnnnnnr yumi232 amator265 rekrutacja alex7 bohdankuts nikitakoshakov yevgeniy8 lena1206 xx_nf_xx neoyarik jan_mapper yurii.repalo nastya000 olga vovenarg neogame camed1955 racibo urbalazs yamaxim gwin gisfile onorua
  
# 11.11.2016 
#for username in tkukovska hast blackbird27 velmyshanovnyi denys severyndubyk serhijdubyk turchin slandewi ivic4u imsamurai older anastacia kuka wowik approksimator roman_ty andygol tavi ghostishev olenas virtakuono ikovaltaras nastya000 serge zakharchenko sergey82k annatop yaras svetlulichka dianka r1kki filutkie maxim75 olena westbam algot b108 vladbudyansky mike140 sanjak tretyakov wiktorn cartolab vatruha tanya_mukha durko_freemap aleksandrb99 gavrss zvid sergiokozzy prudenko alexkolodko dmatushe edjone urken91 igorshv2006 javnik artem ahojmedia serhiidotsenko broztyto alkarol zcor czyk mariya urban4ik baditaflorin openihatebot dmbreaker buravchenko_ek vettellfc vsviridov a_biatov qivi svetlana nastya1230003 serhidotzenko akimchenko heleeeeeen noface nemirovayulia thema13 any sevar szymonowski tetianachukhno yurets_zil cut ninnnnnnr yumi232 amator265 tommasz rekrutacja alex7 bohdankuts nikitakoshakov yevgeniy8 lena1206 xx_nf_xx neoyarik jan_mapper yurii.repalo hubertj olga vovenarg neogame camed1955 racibo urbalazs yamaxim gwin gisfile onorua rangrr
      
# 11.11.2016     
#for username in tkukovska hast blackbird27 velmyshanovnyi slandewi tanya_mukha anastacia denys severyndubyk serhijdubyk turchin ivic4u imsamurai older kuka wowik approksimator diana_b roman_ty vladbudyansky andygol ghostishev dianka olenas svetlulichka annatop virtakuono ikovaltaras serge zakharchenko sergey82k r1kki yaras nastya000 filutkie arto maxim75 olena westbam algot b108 mike140 tretyakov chugaister cartolab vatruha sanjak aleksandrb99 gavrss tavi sergiokozzy prudenko alexkolodko dmatushe edjone urken91 igorshv2006 artem ahojmedia serhiidotsenko wiktorn broztyto alkarol zcor mariya urban4ik czyk openihatebot dmbreaker buravchenko_ek vettellfc a_biatov qivi svetlana serhidotzenko akimchenko heleeeeeen zvid noface nemirovayulia thema13 durko_freemap javnik any sevar tetianachukhno yurets_zil szymonowski cut ninnnnnnr yumi232 amator265 rekrutacja alex7 bohdankuts nikitakoshakov alexrol yevgeniy8 lena1206 xx_nf_xx neoyarik yurii.repalo tommasz olga hubertj vovenarg neogame camed1955 racibo yamaxim gwin gisfile onorua rangrr
 
# 16.16.2016  
#for username in tkukovska hast blackbird27 velmyshanovnyi slandewi tanya_mukha anastacia denys algot severyndubyk serhijdubyk turchin ivic4u imsamurai older approksimator kuka wowik diana_b roman_ty vladbudyansky andygol ghostishev dianka olenas svetlulichka annatop virtakuono ikovaltaras serge zakharchenko sergey82k r1kki yaras nastya000 filutkie arto maxim75 olena westbam b108 mike140 tretyakov chugaister cartolab vatruha sanjak aleksandrb99 gavrss tavi sergiokozzy prudenko alexkolodko dmatushe edjone urken91 igorshv2006 artem ahojmedia serhiidotsenko wiktorn broztyto alkarol zcor mariya urban4ik czyk openihatebot dmbreaker buravchenko_ek vettellfc a_biatov qivi svetlana serhidotzenko akimchenko heleeeeeen zvid noface nemirovayulia thema13 durko_freemap javnik any sevar tetianachukhno yurets_zil szymonowski cut ninnnnnnr yumi232 amator265 rekrutacja alex7 bohdankuts nikitakoshakov alexrol yevgeniy8 lena1206 xx_nf_xx neoyarik yurii.repalo tommasz olga hubertj vovenarg neogame camed1955 racibo yamaxim gwin gisfile onorua rangrr

for username in hast
	
# zibi-osm z-yurets

#for username in hast
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


```    
    [ "${MAPILLARYUSER}" != 'z-yurets' ] && ( 
        echo -e "\e[32m"$MAPILLARYUSER", I'm start import your GPS traces in database\e[0m"
        ogr2ogr -overwrite -s_srs "+init=epsg:4326" -t_srs "+init=epsg:4326" -f "PostgreSQL" PG:"host=$HOST user=$USER dbname=$DBNAME password=$PGPASSWORD" "_merge_gpx/"${MAPILLARYUSER}".gpx" -nln "gpx_user_"${MAPILLARYUSER}

        psql -h $HOST -p $PORT -d $DBNAME -U $USER -c "ALTER TABLE gpx_user_${MAPILLARYUSER} DROP COLUMN track_fid,DROP COLUMN track_seg_id, 
            DROP COLUMN track_seg_point_id, DROP COLUMN ele, DROP COLUMN magvar, DROP COLUMN geoidheight, DROP COLUMN cmt, DROP COLUMN src, 
            DROP COLUMN link1_href, DROP COLUMN link1_text, DROP COLUMN link1_type, DROP COLUMN link2_href, DROP COLUMN link2_text,
            DROP COLUMN link2_type, DROP COLUMN sym, DROP COLUMN type, DROP COLUMN fix, DROP COLUMN sat, DROP COLUMN hdop, DROP COLUMN vdop,
            DROP COLUMN pdop, DROP COLUMN ageofdgpsdata, DROP COLUMN dgpsid;"
	  
        psql -h $HOST -p $PORT -d $DBNAME -U $USER -c "UPDATE gpx_user_${MAPILLARYUSER} SET name = '${MAPILLARYUSER}'"
        
        exit 1 
    ) 
    
    [ "${MAPILLARYUSER}" = 'z-yurets' ] && ( 
        echo -e "\e[32m"$MAPILLARYUSER", I'm start import your GPS traces in database\e[0m"
        ogr2ogr -overwrite -s_srs "+init=epsg:4326" -t_srs "+init=epsg:4326" -f "PostgreSQL" PG:"host=$HOST user=$USER dbname=$DBNAME password=$PGPASSWORD" "_merge_gpx/"${MAPILLARYUSER}".gpx" -nln "gpx_user_z_yurets"

        psql -h $HOST -p $PORT -d $DBNAME -U $USER -c "ALTER TABLE gpx_user_z_yurets DROP COLUMN track_fid,DROP COLUMN track_seg_id, 
            DROP COLUMN track_seg_point_id, DROP COLUMN ele, DROP COLUMN magvar, DROP COLUMN geoidheight, DROP COLUMN cmt, DROP COLUMN src, 
            DROP COLUMN link1_href, DROP COLUMN link1_text, DROP COLUMN link1_type, DROP COLUMN link2_href, DROP COLUMN link2_text,
            DROP COLUMN link2_type, DROP COLUMN sym, DROP COLUMN type, DROP COLUMN fix, DROP COLUMN sat, DROP COLUMN hdop, DROP COLUMN vdop,
            DROP COLUMN pdop, DROP COLUMN ageofdgpsdata, DROP COLUMN dgpsid;"
	  
        psql -h $HOST -p $PORT -d $DBNAME -U $USER -c "UPDATE gpx_user_z_yurets SET name = 'z-yurets'"
        
        exit 1 
    )  
```
	echo ""
done

# download ukraine-latest.osm.pbf from http://download.geofabrik.de site
#wget -O ${HOME}/osmpa/osmdata/ukraine-latest.osm.pbf "http://download.geofabrik.de/europe/ukraine-latest.osm.pbf" ${HOME}/osmpa/osmdata

# import OpenStreetMap pzf features in database | 10.11.2015 - 2m40s for Ukraine | using imposm3 by olehz
#osmpa/imposm_olehz/imposm3 import -read osmpa/osmdata/ukraine-latest.osm.pbf -write -cachedir osmpa/cache -connection "postgis://$USER:$PGPASSWORD@$HOST:5432/$DBNAME?sslmode=disable&prefix=NONE" -dbschema-import public -mapping osmpa/mapping.json -diff -srid 4326 -overwritecache

# get statistics
#psql -h $HOST -p $PORT -d $DBNAME -U $USER -f psql_query.sql

# export pzf features to GeoJSON file with simplify 
#| 10.11.2015 - 1158 features for Ukraine
#| 10.05.2016 - 1414 features for Ukraine
#rm -R data/pzf.geojson
#ogr2ogr -nlt POLYGON -f "GeoJSON" data/pzf.geojson PG:"host=$HOST user=$USER dbname=$DBNAME password=$PGPASSWORD" nature_conservation_polygon -simplify 0.00035 -lco COORDINATE_PRECISION=5

#ogr2ogr -nlt GEOMETRY -f "GeoJSON" data/photo_point.geojson PG:"host=$HOST user=$USER dbname=$DBNAME password=$PGPASSWORD" data_first_in_np -lco COORDINATE_PRECISION=5 -select geom


