#!/bin/sh

#prep the output dirs
if [ ! -e /downloads/Complete ]; then
	mkdir -p /downloads/Complete
	mkdir -p /downloads/Torrents
	mkdir -p /downloads/InProgress
	mkdir -p /downloads/Drop
fi

# check if config exists in /config and set it up if not
if [ ! -e /config/auth ]; then
	#create a default user (apart from admin/deluge)
	#echo "user:Password1:10" >> /config/auth

	#daemon must be running to setup
	deluged -c /config

	#need a small delay here or the first config setting fails
	sleep 1

	#enable report connections (for webui to connect to backend)
	deluge-console -c /config "config -s allow_remote True"
	#view it with: deluge-console -c /config "config allow_remote"

	#setup the paths
	deluge-console -c /config "config -s move_completed_path /downloads/Complete"
	deluge-console -c /config "config -s torrentfiles_location /downloads/Torrents"
	deluge-console -c /config "config -s download_location /downloads/InProgress"
	deluge-console -c /config "config -s autoadd_location /downloads/Drop"

	#daemon port which the WEB ui connects to
	deluge-console -c /config "config -s daemon_port 58846"

	deluge-console -c /config "config -s upnp False"
	deluge-console -c /config "config -s compact_allocation False"
	deluge-console -c /config "config -s add_paused False"
	deluge-console -c /config "config -s move_completed True"
	deluge-console -c /config "config -s copy_torrent_file True"
	deluge-console -c /config "config -s autoadd_enable True"

	#BT port:
	deluge-console -c /config "config -s listen_ports (58332, 58333)"
	#default is (6881, 6891)
	deluge-console -c /config "config -s random_port False"

	deluge-console -c /config "halt"
fi

echo Starting up now ...
deluged -c /config
deluge-web -c /config
