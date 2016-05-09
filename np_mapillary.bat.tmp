@echo off

:: cd /D D:/np.mapillary.tools
:: np_mapillary.bat

:: database settings
set HOST=localhost
set PORT=5432
set DBNAME=mapillary
set USER=postgres
set PASSWORD=postgres

:: download_gpx_from_sequences.py settings
:: Kharkov BBOX:
:: BBOX='49.855693 50.114207 36.072235 36.479416'
:: Ukraine BBOX:
set BBOX=44.28 52.43 40.34 21.97
set MAXRESULTS=9999

FOR %%u IN (alex7 algot alkarol andygol b108 baditaflorin cartolab cut dmbreaker durko_freemap edjone ghostishev gwin hast ikovaltaras imsamurai ivic4u jan_mapper maxim75 older prudenko sanjak serge serhijdubyk severyndubyk urbalazs velmyshanovnyi vsviridov wiktorn yamaxim yevgeniy8 zvid) do ( 
::FOR %%u IN (hast prudenko severyndubyk) do (

	rm -R _gpx
	rm -R _merge_gpx
	mkdir _merge_gpx

	python mapillary_tools/download_gpx_from_sequences.py -r %BBOX% -m %MAXRESULTS% -u %%u

	python mapillary_tools/join_gpx_mapillary_files.py _gpx _merge_gpx/%%u.gpx

	ogr2ogr  -overwrite -s_srs "+init=epsg:4326" -t_srs "+init=epsg:4326" -f "PostgreSQL" PG:"host=%HOST% user=%USER% dbname=%DBNAME% password=%PASSWORD%" _merge_gpx/%%u.gpx -nln gpx_user_%%u
		
	psql -h %HOST% -p %PORT% -d %DBNAME% -U %USER% -c "ALTER TABLE gpx_user_%%u DROP COLUMN track_fid, DROP COLUMN track_seg_id, DROP COLUMN track_seg_point_id, DROP COLUMN ele, DROP COLUMN magvar, DROP COLUMN geoidheight, DROP COLUMN cmt, DROP COLUMN src, DROP COLUMN link1_href, DROP COLUMN link1_text, DROP COLUMN link1_type, DROP COLUMN link2_href, DROP COLUMN link2_text, DROP COLUMN link2_type, DROP COLUMN sym, DROP COLUMN type, DROP COLUMN fix, DROP COLUMN sat, DROP COLUMN hdop, DROP COLUMN vdop, DROP COLUMN pdop, DROP COLUMN ageofdgpsdata, DROP COLUMN dgpsid;"
	  
	psql -h %HOST% -p %PORT% -d %DBNAME% -U %USER% -c "UPDATE gpx_user_%%u SET name = '%%u'"
	
)	

rm -R data/nature_conservation_polygon.geojson
ogr2ogr -nlt POLYGON -f "GeoJSON" data/nature_conservation_polygon.geojson PG:"host=%HOST% user=%USER% dbname=%DBNAME% password=%PASSWORD%" nature_conservation_polygon -simplify 0.001 -lco COORDINATE_PRECISION=5

psql -h %HOST% -p %PORT% -d %DBNAME% -U %USER% -f psql_query.sql	
	
	
	
	
	
	
	
	
	
	
	
	
	
	