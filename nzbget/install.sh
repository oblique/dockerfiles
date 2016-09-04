#!/bin/sh
set -e

apk add --no-cache curl shadow

mkdir -p /opt
cd /opt

# install NZBGet
ver=$(curl https://github.com/nzbget/nzbget/releases/latest | sed 's|.*tag/v\([^"]\+\).*|\1|')
curl -L -o nzbget-bin.run https://github.com/nzbget/nzbget/releases/download/v${ver}/nzbget-${ver}-bin-linux.run
chmod +x nzbget-bin.run
./nzbget-bin.run
rm -f nzbget-bin.run
