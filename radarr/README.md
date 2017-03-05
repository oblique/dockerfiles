## Image

Docker image of [Radarr](https://radarr.video).

## Environment variables

* `PUID` - UID of the process (default: 1000)
* `PGID` - GID of the process (default: 1000)

## Usage

```
docker run -d \
    -p 7878:7878 \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v /etc/localtime:/etc/localtime:ro \
    -v /path/to/config:/config \
    -v /path/to/downloads:/data \
    oblique/radarr
```
