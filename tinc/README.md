## Usage

```
docker run -d \
    -v /etc/tinc:/etc/tinc \
    -e NETNAME=net-name \
    --net=host --cap-add NET_ADMIN --device=/dev/net/tun \
    oblique/tinc
```
