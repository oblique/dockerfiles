## Image

Docker image for [NGINX](https://www.nginx.com) with autoindex enabled.

## Environment variables

* `PUID` - UID of the process
* `PUID` - GID of the process

## Usage

```
docker run -d -p 80:80 \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v /path:/usr/share/nginx/html:ro \
    oblique/nginx-autoindex
```
