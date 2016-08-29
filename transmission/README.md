## Image

Docker image for [transmission](https://www.transmissionbt.com/) daemon.

## Environment variables

* `PUID` - UID for the transmission-daemon (default: 0)
* `PGID` - GID for the transmission-daemon (default: 0)
* `PEER_PORT` - Port to listen for incoming peers on (default: 51413)
* `AUTH_USERNAME` - Username for client authentication
* `AUTH_PASSWORD` - Password for client authentication
* `DOWNLOAD_DIR` - Where to store downloaded data (default: /data)
* `INCOMPLETE_DIR` - Where to store data of incomplete torrents
* `WATCH_DIR` - Where to watch for new .torrent files

## Usage

### Basic

```
docker run -d -p 9091:9091 \
    -p 51413:51413 -p 51413:51413/udp \
    -e PUID=$(id -u)
    -e PGID=$(id -g)
    -v /etc/localtime:/etc/localtime:ro \
    -v /path/to/config:/config \
    -v /path/to/downloads:/data \
    oblique/transmission
```

### Advanced

```
docker run -d -p 9091:9091 \
    -e PEER_PORT=12345 -p 12345:12345 -p 12345:12345/udp \
    -e PUID=$(id -u)
    -e PGID=$(id -g)
    -e AUTH_USERNAME=admin -e AUTH_PASSWORD=pass \
    -e DOWNLOAD_DIR=/data/complete \
    -e INCOMPLETE_DIR=/data/incomplete \
    -e WATCH_DIR=/data/watch \
    -v /etc/localtime:/etc/localtime:ro \
    -v /path/to/config:/config \
    -v /path/to/downloads:/data \
    oblique/transmission
```

### Using UPnP

```
docker run -d --net=host \
    -e PUID=$(id -u)
    -e PGID=$(id -g)
    -v /etc/localtime:/etc/localtime:ro \
    -v /path/to/config:/config \
    -v /path/to/downloads:/data \
    oblique/transmission
```
