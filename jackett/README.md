## Image

Docker image for [Jackett](https://github.com/Jackett/Jackett)

## Environment variables

* `PUID` - UID for the transmission-daemon (default: 1000)
* `PGID` - GID for the transmission-daemon (default: 1000)

## Usage

```
docker run -d -p 9117:9117 \
    -e PUID=$(id -u)
    -e PGID=$(id -g)
    -v /path/to/config:/config \
    oblique/jackett
```
