Setup Mullvad VPN the first time only:

```bash
docker-compose up -d mullvad
docker-compose exec mullvad bash

# In container
mullvad relay set tunnel-protocol wireguard
mullvad always-require-vpn set on
mullvad auto-connect set on
mullvad account set [ID]
mullvad connect
exit

# Out of the container
docker-compose down
```

Start it:

```bash
docker-compose up -d
```

You can see the VPN IP with:

```bash
docker-compose logs -f ip
```
