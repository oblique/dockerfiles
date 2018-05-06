#!/bin/sh
set -e

github_latest_release() {
    curl -L "https://api.github.com/repos/${1}/releases/latest" 2> /dev/null | \
        grep -m1 tag_name | sed 's|.*"tag_name": "v\([^"]\+\).*|\1|'
}

# install dependencies
apk add --no-cache tini bash curl openssl docker python3 groff jq diffutils

# install dehydrated
ver=$(github_latest_release lukas2511/dehydrated)
mkdir -p /opt
cd /opt
curl -L -o dehydrated.tar.gz https://github.com/lukas2511/dehydrated/archive/v${ver}.tar.gz
tar zxvf dehydrated.tar.gz
rm -f dehydrated.tar.gz
mv dehydrated* dehydrated

# install aws
apk add --no-cache musl-dev python3-dev make gcc
pip3 install awscli
apk del --no-cache musl-dev python3-dev make gcc
