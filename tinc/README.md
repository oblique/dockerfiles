## Usage

```
docker run -d \
    -v /etc/tinc:/etc/tinc \
    --net=host --cap-add NET_ADMIN --device=/dev/net/tun \
    oblique/tinc
```
