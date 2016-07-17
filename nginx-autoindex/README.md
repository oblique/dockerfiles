# NGINX with autoindex enabled

## Environment variables

* `NIGNX_UID` - Change UID of nginx process
* `NIGNX_UID` - Change GID of nginx process

## Usage

```
docker run -d -p 80:80 -e NIGNX_UID=$UID -e NIGNX_GID=$GID \
    -v /path:/usr/share/nginx/html:ro \
    oblique/nginx-autoindex
```
