*Boot an Instance*
	ec2-run-instances ami-13373367 -n 2 --instance-type m1.xlarge --region eu-west-1 --user-data-file maps-init.txt -k map-test-large-2 -g quicklaunch-1

*Setup*

Each instance is configured with 2 ephemeral disks. One is mounted on <pre>/mnt</pre> and contains the scripts, raw data and tile cache. The other 
is mounted on <pre>/mnt/data</pre> and holds the postgres database.

==Setup Steps==
*Optional*
	sudo apt-add-repository -y ppa:mapnik/nightly-2.0

*Mandatory*
	sudo apt-get update
	sudo apt-get install -y build-essential python-dev python-pip python-imaging zlib1g-dev postgresql-9.1-postgis \
	postgresql-server-dev-9.1 mapnik-utils git htop libjson0 libjson0-dev python-mapnik2 \
	protobuf-c-compiler protobuf-compiler libprotobuf-dev libtokyocabinet-dev python-psycopg2 libgeos-c1 libgeos-dev python-pip
	sudo pip install tilestache
	sudo pip install modestmaps
	sudo pip install cssutils
	sudo pip install cascadenik
	sudo pip install imposm

*Create Database*
 	echo "create user osm superuser; create database planet_osm owner osm;" | psql -U postgres
	cat /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql |psql -U osm planet_osm
	cat /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql |psql -U osm planet_osm

*RAM Disk*
	sudo mount -t tmpfs -o rw,size=50G /dev/ram1 /tmp/ramdisk

*Get the code* 
	git clone http://github.com/migurski/OSM-Solar.git

*Coastline*
	/usr/lib/postgresql/9.1/bin/shp2pgsql -s 900913 -I -D -d processed_p.shp coastline |psql -U osm planet

*Imposm*
	imposm -m imposm-mapping.py --write -U osm -d planet --read ../canv.pbf --concurrency 3 --overwrite-cache --deploy-production-tables

==Notes==
	1. xlarge instances are very hit-or-miss regarding I/O throughput. They are not high priority instances, but have lots of ephemeral storage. This causes
	   some difficulty when trying to compare various instance types.
	2. 4xlarge instances have great I/O priority and RAM availability. It might be advisable to have predictable performance in some cases.
	3. Memory Tweaks on 4xl:
		3.3. Kernel
		sudo sysctl -w kernel.shmmax=71881932800
		sudo sysctl -w kernel.shmall=17549300
	3.3. Postgres
		max_connections = 5
		shared_buffers = 5GB
		work_mem = 16MB 
		max_stack_depth = 7680kB
		autovacuum = off


