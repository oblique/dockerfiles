#!/bin/sh
set -e

github_latest_release() {
    curl -L "https://api.github.com/repos/${1}/releases/latest" 2> /dev/null | \
        grep -m1 tag_name | sed 's|.*"tag_name": "v\([^"]\+\).*|\1|'
}

apk add --no-cache curl shadow supervisor unrar

mkdir -p /opt
cd /opt

# install headphones
ver=$(github_latest_release rembo10/headphones)
curl -L -o headphones.tar.gz https://github.com/rembo10/headphones/archive/v${ver}.tar.gz
tar xvf headphones.tar.gz
rm -rf headphones.tar.gz
[ -d ./headphones ] || mv headphones* headphones
