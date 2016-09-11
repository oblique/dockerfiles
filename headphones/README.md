## Image

Docker image of [Headphones](https://github.com/rembo10/headphones)

## Environment variables

* `PUID` - UID of the process (default: 1000)
* `PGID` - GID of the process (default: 1000)

## Usage

```
docker run -d -p 8181:8181 \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v /etc/localtime:/etc/localtime:ro \
    -v /path/to/config:/config \
    -v /path/to/music:/data \
    oblique/headphones
```
