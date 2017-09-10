# docker-deluge
A basic deluge docker container, based on the latest Alpine Linux base image and uses the testing repo to pull in deluge.

Three TCP ports are exposed;

* 8112 is the web client port
* 58332 is the port you should forward from your router for incoming BitTorrent access
* 58846 is the port the deluge daemon runs on, the webui needs to connect to this port from your browser

The downloads volume is where temporary downloads are, and where the resulting files end up. It's preconfigured to keep everything separate, and these directories will be created if missing when the container starts.

* Torrents - contains copys of all torrents supplied, in case you want to keep them separate for some reason
* Complete - all completed downloads moved here (can be overridden in the gui for all or per download)
* Drop - drop target where you can add torrent files without using the gui
* InProgress - incomplete downloads are stored here. These will be sparse files by default.

To access the web-ui, simply point your browser at http://<your docker host>:8112 and login with the default password *deluge*. If this prompts for a username too, it's *admin* by default.

Quick start (config files are created in config volume automatically):
```shell
docker run -d -p 8112:8112 -p 58332:58332 -p 58846:58846 -v /path/to/config:/config -v /path/to/downloads:/downloads --name deluge tardfree/docker-deluge
```

To have the container start when the host boots, add docker's restart policy:
```shell
docker run -d --restart=always -p 8112:8112 -p 58332:58332 -p 58846:58846 -v /path/to/config:/config -v /path/to/downloads:/downloads --name deluge tardfree/docker-deluge
```

