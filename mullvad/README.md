## Image

Docker image of [mullvad](https://mullvad.net/en/)

## Usage

Start container:

```
docker run -d \
    --name mullvad_vpn \
    --restart=always \
    --privileged \
    -v mullvad_config:/config \
    oblique/mullvad
```

The first time you need to configure your mullvad client:

```
docker exec -it mullvad_vpn bash
mullvad relay set tunnel-protocol wireguard
mullvad always-require-vpn set on
mullvad auto-connect set on
mullvad account set [ID]
mullvad connect
```

## Use VPN from another container

Use `--net=container:mullvad_vpn`, for example:

```
docker run -it --rm --net=container:mullvad_vpn alpine
```
