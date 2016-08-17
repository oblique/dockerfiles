## Image

Docker image for [transmission](https://www.transmissionbt.com/) daemon.

## Environment variables

* `PEER_PORT` - Port to listen for incoming peers on. Default: 51413
* `AUTH_USERNAME` - Username for client authentication
* `AUTH_PASSWORD` - Password for client authentication
* `DOWNLOAD_DIR` - Where to store downloaded data. Default: /data
* `INCOMPLETE_DIR` - Where to store data of incomplete torrents
* `WATCH_DIR` - Where to watch for new .torrent files

## Usage

### Basic

```
docker run -d -u $(id -u):$(id -g) -p 9091:9091 \
    -p 51413:51413 -p 51413:51413/udp \
    -v /etc/localtime:/etc/localtime:ro \
    -v /path/to/config:/config \
    -v /path/to/downloads:/data \
    oblique/transmission
```

### Advanced

```
docker run -d -u $(id -u):$(id -g) -p 9091:9091 \
    -e PEER_PORT=12345 -p 12345:12345 -p 12345:12345/udp \
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
docker run -d -u $(id -u):$(id -g) --net=host \
    -v /etc/localtime:/etc/localtime:ro \
    -v /path/to/config:/config \
    -v /path/to/downloads:/data \
    oblique/transmission
```
