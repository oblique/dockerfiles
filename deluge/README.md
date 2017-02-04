## Image

Docker image of [Deluge](http://deluge-torrent.org).

Default password for webui: `deluge`

## Environment variables

* `PUID` - UID of the process (default: 1000)
* `PGID` - GID of the process (default: 1000)
* `UPNP` - Enable/Disable UPnP
* `NAT_PMP` - Enable/Disable NAT-PMP
* `UTPEX` - Enable/Disable Peer Exchange
* `LSD` - Enable/Disable LSD
* `DHT` - Enable/Disable DHT
* `UTP` - Enable/Disable uTP
* `INCOMING_PORT_RANGE` - Specify incoming ports
* `OUTGOING_PORT_RANGE` - Specify outgoing ports

## Ports

* `8112` TCP - Deluge Web UI
* `58846` TCP - Deluge daemon

## Usage

```
docker run -d \
    -p 8112:8112 \
    -p 58846:58846 \
    -p 58123:58123 -p 58123:58123/udp \
    -e INCOMING_PORT_RANGE=58123-58123 \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v /etc/localtime:/etc/localtime:ro \
    -v /path/to/config:/config \
    -v /path/to/downloads:/data \
    oblique/deluge
```
