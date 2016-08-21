## Image

Docker image for [couchpotato](https://github.com/CouchPotato/CouchPotatoServer).

## Usage

```
docker run -d -u $(id -u):$(id -g) -p 5050:5050 \
    -v /etc/localtime:/etc/localtime:ro \
    -v /path/to/config:/config \
    -v /path/to/downloads:/data \
    oblique/couchpotato
```
