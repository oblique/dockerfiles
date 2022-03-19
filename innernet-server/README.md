# Initial setup

Run:

```
docker run -it --rm \
    -v /root/innernet-config:/config \
    -v /root/innernet-data:/data \
    oblique/innernet-server \
    bash
```

And within the container do:

```
# Create the innernet network

root@dcb16d91f878:/# innernet-server -c /config -d /data new
  Network name: mynet
  Network CIDR: 10.42.0.0/16
  Listen port: 51820
  Auto-fill public IP address (via a DNS query to 1.1.1.1)?: yes
  External endpoint: [ENTER]


# Add your first CIDR

root@dcb16d91f878:/# innernet-server -c /config -d /data add-cidr mynet
  ? Parent CIDR:
  > mynet (10.42.0.0/16) [ENTER]
  Name: home
  CIDR: 10.42.1.0/24
  Create CIDR "home"?: yes


# Add your first peer

root@dcb16d91f878:/# innernet-server -c /config -d /data add-peer mynet
  ? Eligible CIDRs for peer:
  > home (10.42.1.0/24) [ENTER]
  IP: 10.42.1.1
  Name: your-name
  Make your-name an admin?: yes
  Invite expires after (14d): [ENTER]
  Save peer invitation file to (your-name.toml): [ENTER]
  Create peer your-name? (y/n): yes
```

The above will create an invitation for your first peer, use `cat your-name.toml`
to see the content and copy it on your machine. You will need it in a later
step.

# Start the server

```
docker run -d --restart=always \
    --cap-add=NET_ADMIN -p 51820:51820/udp \
    -v /root/innernet-config:/config \
    -v /root/innernet-data:/data \
    -e NETWORK_NAME=mynet \
    oblique/innernet-server
```

# Finalize setup

Now you can use the invitation that we create in the first step to add the
first peer:

```
root@machine:~# innernet install /tmp/your-name.toml
  Interface name: mynet
  Delete invitation file "/tmp/your-name.toml" now? (It's no longer needed) (y/n): yes
root@machine:~# systemctl enable --now innernet@mynet
```
