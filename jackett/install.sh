#!/bin/bash
set -e

github_latest_release() {
    curl -L "https://api.github.com/repos/${1}/releases/latest" 2> /dev/null | \
        grep -m1 tag_name | sed 's|.*"tag_name": "v\([^"]\+\).*|\1|'
}

pacman --noconfirm -Syyu mono curl supervisor

mkdir -p /build
cd /build

# install jackett
ver=$(github_latest_release Jackett/Jackett)
curl -L -o jackett.tar.gz https://github.com/Jackett/Jackett/releases/download/v${ver}/Jackett.Binaries.Mono.tar.gz
tar xvf jackett.tar.gz -C /opt
[[ -d /opt/Jackett ]] || mv /opt/Jackett* /opt/Jackett

# install jackett-public
ver=$(github_latest_release dreamcat4/Jackett-public)
curl -L -o jackett-public.tar.gz https://github.com/dreamcat4/Jackett-public/releases/download/v${ver}/Jackett-public.Binaries.Mono.tar.gz
tar xvf jackett-public.tar.gz -C /opt
[[ -d /opt/Jackett-public ]] || mv /opt/Jackett-public* /opt/Jackett-public

cd /
rm -rf /build
