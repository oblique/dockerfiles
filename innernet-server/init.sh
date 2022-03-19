#!/bin/bash

exec innernet-server -c /config -d /data serve "$NETWORK_NAME"
