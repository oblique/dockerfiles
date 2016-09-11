## Image

Docker image of [Jackett](https://github.com/Jackett/Jackett) and [Jackett Public](https://github.com/dreamcat4/Jackett-public).

Jackett is listening to port 9117 and Jackett Public to port 9118.

## Environment variables

* `PUID` - UID of the process (default: 1000)
* `PGID` - GID of the process (default: 1000)

## Usage

```
docker run -d -p 9117:9117 -p 9118:9118 \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v /path/to/config:/config \
    oblique/jackett
```
