## Image

This image connects to [AirVPN's server](https://airvpn.org) and creates Socks5
proxy on port `1080`. If for any reason the VPN stops working then all the
connections are blocked to avoid any leaks.

## Environment variables

* `COUNTRY` - Specify the name of the country. (e.x. `us`, `de`, `gb`)
* `SERVER` - Specify the name of the server. This overrides `COUNTRY`.
* `MODE` - Specify the type of connection.
* `INSECURE_STUNNEL` - Disables certificate verification for `stunnel`. This is needed if you are behind a firewall that monitors SSL.

## Mode format

Mode contains the type of connection you want, the port, and if you want to use
an alternative entry IP. For more info about modes check
[AirVPN's Config Generator](https://airvpn.org/generator/).

The first part of the mode must contain the type of the connection, which can
be one the following: `udp`, `tcp`, `ssl`, `ssh`.
Then you can specify the port you want and if you want to connect to the alternative entry IP.

### Examples

```
udp
udp-53
udp-alt
udp-altentry
udp-53-alt
udp-53-altentry
```

## Usage

```
docker run -d \
    --cap-add=NET_ADMIN \
    -p 127.0.0.1:1080:1080 \
    -v /your_airvpn_configs:/airvpn \
    -e COUNTRY=se \
    oblique/airvpn
```

```
docker run -d \
    --cap-add=NET_ADMIN \
    -p 127.0.0.1:1080:1080 \
    -v /your_airvpn_configs:/airvpn \
    -e COUNTRY=se \
    -e MODE=ssl \
    -e INSECURE_STUNNEL \
    oblique/airvpn
```

## Advance usage - Attach another container to it

In my example I will use [obliqe/deluge](https://hub.docker.com/r/oblique/deluge/) image,
which needs to expose `8112` and `58846` ports. In this case the ports must be specified
on `oblique/airvpn` image.

Notice that I don't specify `58123` and `58124` ports, because these ports need
to go through the VPN connection. You need to forward them in
[AirVPN's Forwarded Ports](https://airvpn.org/ports/) page.

```
docker run -d \
    --cap-add=NET_ADMIN \
    -p 127.0.0.1:1080:1080 \
    --name vpn \
    -p 8112:8112 \
    -p 58846:58846 \
    -v /your_airvpn_configs:/airvpn \
    -e COUNTRY=se \
    oblique/airvpn
```

```
docker run -d \
    --net=container:vpn \
    -e PUID=$(id -u) \
    -e PGID=$(id -g) \
    -v /etc/localtime:/etc/localtime:ro \
    -v /path/to/config:/config \
    -v /path/to/downloads:/data \
    oblique/deluge
```
