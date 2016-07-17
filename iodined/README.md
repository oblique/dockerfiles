## iodine server

Docker image for [iodine](http://code.kryo.se/iodine/) server.

## Environment variables

* `IODINED_TOP_DOMAIN` - DNS tunnel domain (mandatory)
* `IODINED_PASSWORD` - Password (mandatory)
* `IODINED_TUN_IP` - Tunnel IP, default: `10.0.0.1/24` (optional)
* `IODINED_EXT_IP` - External IP of your server, default: auto-detected (optional)

## Usage

```
docker run -d --privileged -p 53:53/udp -e IODINED_TOP_DOMAIN=tun.example.com \
    -e IODINED_PASSWORD=mypassword oblique/iodined
```
