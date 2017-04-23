## Image

This image creates WebDAV server using Apache HTTP Server.

## Environment variables

`USER` - Set temporary username (this is ignored if HTPASSWD_PATH is defined)
`PASSWORD` - Set temporary password (this is ignored if HTPASSWD_PATH is defined)
`HTPASSWD_PATH` - Set path of htpasswd file (default: /config/htpasswd)
`USE_SSL` - Enable https on port 443 (default: false)
`ONLY_SSL` - Enable https on port 443 and disables port 80 (default: false)
`CERT_PATH` - Set path of certificate (default: /config/cert.pem)
`KEY_PATH` - Set path of private key (default: /config/key.pem)
`DHPARAM_PATH` - Set path of dhparam file (default: /config/dhparam.pem)

## Usage

```
docker run -d -p 80:80 -v /path/to/data:/data oblique/webdav
```

```
docker run -d -p 80:80 -v /path/to/data:/data \
    -e USER=test -e PASSWORD=12345678 \
    oblique/webdav
```

```
docker run -d -p 443:443 \
    -v /path/to/certs:/certs \
    -v /path/to/data:/data \
    -e USER=test -e PASSWORD=12345678 \
    -e ONLY_SSL=true \
    -e CERT_PATH=/certs/fullchain.pem \
    -e KEY_PATH=/certs/privkey.pem \
    -e DHPARAM_PATH=/certs/dhparam.pem \
    oblique/webdav
```
