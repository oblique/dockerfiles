## Image

Docker image for [Deluge](http://deluge-torrent.org).

## Environment variables

* `PUID` - UID of the process (default: 1000)
* `PGID` - GID of the process (default: 1000)

## Ports

* `8112` TCP - Deluge Web UI
* `58846` TCP - Deluge daemon
* `58123` TCP and `58123` UDP - Example of port for incoming data (you must define it in the webui)
* `58124` TCP and `58124` UDP - Example of port for outgoing data (you must define it in the webui)

## Usage

```
docker run -d \
    -p 8112:8112 \
    -p 58846:58846 \
    -p 58123:58123 -p 58123:58123/udp \
    -p 58124:58124 -p 58123:58124/udp \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v /etc/localtime:/etc/localtime:ro \
    -v /path/to/config:/config \
    -v /path/to/downloads:/data \
    oblique/deluge
```
