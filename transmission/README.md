## Image

Docker image for [transmission](https://www.transmissionbt.com/) daemon.

## Environment variables

* `PEER_PORT` - Port to listen for incoming peers on. Default: 51413
* `AUTH_USERNAME` - Username for client authentication
* `AUTH_PASSWORD` - Password for client authentication

## Usage

### Basic

```
docker run -d -u $(id -u):$(id -g) -p 9091:9091 \
    -p 51413:51413 -p 51413:51413/udp \
    -v /path/to/downloads:/downloads \
    -v /path/to/config:/config \
    -v /path/to/watch:/watch \
    -v /etc/localtime:/etc/localtime:ro \
    oblique/transmission
```

### Authentication and another peer port

```
docker run -d -u $(id -u):$(id -g) -p 9091:9091 \
    -e PEER_PORT=12345 -p 12345:12345 -p 12345:12345/udp \
    -e AUTH_USERNAME=admin -e AUTH_PASSWORD=pass \
    -v /path/to/downloads:/downloads \
    -v /path/to/config:/config \
    -v /path/to/watch:/watch \
    -v /etc/localtime:/etc/localtime:ro \
    oblique/transmission
```

### Using UPnP

```
docker run -d -u $(id -u):$(id -g) --net=host \
    -v /path/to/downloads:/downloads \
    -v /path/to/config:/config \
    -v /path/to/watch:/watch \
    -v /etc/localtime:/etc/localtime:ro \
    oblique/transmission
```
