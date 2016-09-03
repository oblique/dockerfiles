## Image

Docker image for [couchpotato](https://github.com/CouchPotato/CouchPotatoServer).

## Environment variables

* `PUID` - UID for the transmission-daemon (default: 1000)
* `PGID` - GID for the transmission-daemon (default: 1000)

## Usage

```
docker run -d -u -p 5050:5050 \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v /etc/localtime:/etc/localtime:ro \
    -v /path/to/config:/config \
    -v /path/to/downloads:/data \
    oblique/couchpotato
```
