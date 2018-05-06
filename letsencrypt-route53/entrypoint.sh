#!/bin/bash

cat > /tmp/dehydrated_config << EOF
CHALLENGETYPE=dns-01
DOMAINS_TXT=/tmp/domains.txt
CERTDIR=/certs
KEY_ALGO=rsa
KEYSIZE=4096
HOOK=/opt/route53_hook.sh
LOCKFILE=/tmp/lock
CONTACT_EMAIL=$CONTACT_EMAIL
EOF

exec "$@"
