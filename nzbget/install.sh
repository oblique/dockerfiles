#!/bin/sh
set -e

github_latest_release() {
    curl -L "https://api.github.com/repos/${1}/releases/latest" 2> /dev/null | \
        grep -m1 tag_name | sed 's|.*"tag_name": "v\([^"]\+\).*|\1|'
}

apk add --no-cache curl shadow supervisor

mkdir -p /opt
cd /opt

# install NZBGet
ver=$(github_latest_release nzbget/nzbget)
curl -L -o nzbget-bin.run https://github.com/nzbget/nzbget/releases/download/v${ver}/nzbget-${ver}-bin-linux.run
chmod +x nzbget-bin.run
./nzbget-bin.run
rm -f nzbget-bin.run
