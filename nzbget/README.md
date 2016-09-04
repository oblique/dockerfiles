## Image

Docker image for [NZBGet](http://nzbget.net)

## Environment variables

* `PUID` - UID for the transmission-daemon (default: 1000)
* `PGID` - GID for the transmission-daemon (default: 1000)

## Usage

```
docker run -d -p 6789:6789 \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v /etc/localtime:/etc/localtime:ro \
    -v /path/to/config:/config \
    -v /path/to/downloads:/data \
    oblique/nzbget
```
