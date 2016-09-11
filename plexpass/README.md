## Image

Docker image of [Plex Media Server](https://plex.tv).

## Environment variables

* `PUID` - UID of the process (default: 1000)
* `PGID` - GID of the process (default: 1000)

## Ports

* `32400` TCP - Plex Media Server
* `32469` TCP and `1900` UDP - DLNA Server
* `32410`, `32412`, `32413`, `32414` UDP - Network discovery

## Usage

```
docker run -d \
    -p 32400:32400 \
    -p 32469:32469 -p 1900:1900/udp \
    -p 32410:32410/udp -p 32412:32412/udp -p 32413:32413/udp -p 32414:32414/udp \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v /etc/localtime:/etc/localtime:ro \
    -v /path/to/config:/config \
    -v /path/to/media:/data \
    oblique/plexpass
```
