#!/bin/sh
set -e

github_latest_release() {
    curl -L "https://api.github.com/repos/${1}/releases/latest" 2> /dev/null | \
        grep -m1 tag_name | sed 's|.*"tag_name": "v\([^"]\+\).*|\1|'
}

apk add --no-cache bash curl openssl bind-tools

mkdir -p /opt
cd /opt

# install dehydrated
ver=$(github_latest_release lukas2511/dehydrated)
curl -L -o dehydrated.tar.gz https://github.com/lukas2511/dehydrated/archive/v${ver}.tar.gz
tar zxvf dehydrated.tar.gz
rm -f dehydrated.tar.gz
mv dehydrated* dehydrated
