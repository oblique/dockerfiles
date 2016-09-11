#!/bin/sh
set -e

apk add --no-cache curl shadow supervisor unrar

mkdir -p /opt
cd /opt

# install headphones
ver=$(curl https://github.com/rembo10/headphones/releases/latest | sed 's|.*tag/v\([^"]\+\).*|\1|')
curl -L -o headphones.tar.gz https://github.com/rembo10/headphones/archive/v${ver}.tar.gz
tar xvf headphones.tar.gz
rm -rf headphones.tar.gz
[ -d ./headphones ] || mv headphones* headphones
