Steps
=====

*Optional:*

	sudo apt-add-repository -y ppa:mapnik/nightly-2.0

	sudo apt-get update
	sudo apt-get install -y build-essential python-dev python-pip python-imaging zlib1g-dev postgresql-9.1-postgis \
	postgresql-server-dev-9.1 mapnik-utils git htop libjson0 libjson0-dev python-mapnik2 \
	protobuf-c-compiler protobuf-compiler libprotobuf-dev libtokyocabinet-dev python-psycopg2 libgeos-c1 libgeos-dev python-pip
	sudo pip install tilestache
	sudo pip install modestmaps
	sudo pip install cssutils
	sudo pip install cascadenik
	sudo pip install imposm

RAM Disk
--------
	sudo mount -t tmpfs -o rw,size=50G /dev/ram1 /tmp/ramdisk

Coastline
---------
	/usr/lib/postgresql/9.1/bin/shp2pgsql -s 900913 -I -D -d processed_p.shp coastline |psql -U osm planet

Imposm 
------
	imposm -m imposm-mapping.py --write -U osm -d planet --read ../canv.pbf --concurrency 3 --overwrite-cache --deploy-production-tables

Boot an Instance
----------------
	ec2-run-instances ami-13373367 -n 2 --instance-type m1.xlarge --region eu-west-1 --user-data-file maps-init.txt -k map-test-large-2 -g quicklaunch-1
