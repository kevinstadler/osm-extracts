#!/bin/bash

SITES=(
	Kunming
	Oxford
	Moulsford
	Nunhead
	Glasgow
	Vienna
	Belgrade
	Tulsa
	Edinburgh
#	Josefstadt
#	Erdberg
	SantaFe
	Auckland
)
# W S E N
BBOXES=(
	102.3459,24.7194,103.0085,25.4706
	-89.5951,34.3219,-89.4596,34.4078
	-1.1947,51.5309,-1.0973,51.5788
	-0.1023,51.4367,-0.0025,51.4889
	-4.3178,55.8110,-4.2191,55.8803
	16.1444,48.1033,16.6127,48.3594
	20.2746,44.7092,20.6413,44.8585
	-96.0720,35.9875,-95.7301,36.2374
	-3.2315,55.9268,-3.1548,55.9582 # -3.4160,55.8591,-2.9879,56.0141
#	16.3221,48.2008,16.3649,48.2209
#	16.3784,48.1873,16.4218,48.2075
	-106.0103,35.6268,-105.8964,35.7186
	174.7957,-36.8777,174.8687,-36.8405
)

cd data
export OSM_CONFIG_FILE="../osmtags.ini"

for ((i = 0; i < ${#SITES[@]}; i++)); do
	if [ ! -f "${SITES[i]}.osm.pbf" ]; then
		if [ ! -f "${SITES[i]}.osm" ]; then
			# XAPI: http://overpass.openstreetmap.ru/cgi/xapi?*[bbox=11.5,48.1,11.6,48.2] // xapi_meta for changeset etc
			echo "Downloading ${SITES[i]} (${BBOXES[i]})..."
			wget --no-verbose --show-progress --progress=dot:mega -O "${SITES[i]}.osm" "http://overpass.openstreetmap.ru/cgi/xapi?*[bbox=${BBOXES[i]}]"
		fi
		# https://gis.stackexchange.com/questions/15135/using-field-to-rgb-mapping-for-symbology-in-qgis
		# better: https://gis.stackexchange.com/questions/155395/how-to-style-a-vector-layer-in-qgis-using-hexadecimal-color-code-stored-in-attri
		# https://wiki.openstreetmap.org/wiki/Osmosis/TagTransform
#		echo "Converting ${SITES[i]}.osm to spatialite..."
#		ogr2ogr -a_srs 'EPSG:4326' -f "SQLite" -dsco SPATIALITE=YES "${SITES[i]}.db" "${SITES[i]}.osm"
	fi
done

# LA too large:	-118.56,33.72,-117.85,34.11
# wget "https://app.interline.io/osm_extracts/download_latest?string_id=los-angeles_california&data_format=pbf&api_token=c9a0309e-512b-48df-a3fe-a60c3b8c34dd"
#lon min: -120.7610095
#lon max: -114.5955360
#lat min: 32.9184260
#lat max: 37.3920183
# WSEN: osmconvert los-angeles_california.osm.pbf -b=-118.5782,33.6958,-117.6334,34.1618 -o=LA.osm.pbf

cd ..
