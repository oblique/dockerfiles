#!/bin/bash
set -e
set -u
set -o pipefail

source /etc/dehydrated/config
TTL=${TTL:-300}

case "$1" in
    "deploy_challenge")
        cat << EOF | nsupdate -k $KEY_PATH
server $DNSSERVER
zone $ZONE
update delete _acme-challenge.${2}. IN TXT
update add _acme-challenge.${2}. $TTL IN TXT "${4}"
send
quit
EOF
        ;;
    "clean_challenge")
        cat << EOF | nsupdate -k $KEY_PATH
server $DNSSERVER
zone $ZONE
update delete _acme-challenge.${2}. IN TXT
send
quit
EOF
        ;;
    "deploy_cert")
        cd "$CERTDIR"

        main_domain=$2
        alt_domains=$(openssl x509 -in $main_domain/cert.pem -text | \
            grep -o 'DNS:[^,[:space:]]\+' | sed 's/^DNS://')

        has_dhparam=0
        [[ -e $main_domain/dhparam.pem ]] && has_dhparam=1

        # clean old symlinks
        find -type l -maxdepth 1 | while read x; do
            if readlink "$x" | grep -qE "^${main_domain}/"; then
                rm -f "$x"
            fi
        done

        # create new symlinks
        for x in $alt_domains; do
            ln -s $main_domain/fullchain.pem $x.crt
            ln -s $main_domain/privkey.pem $x.key
            # the very first time dhparam does not exist, do not create broken symlinks
            [[ $has_dhparam -eq 1 ]] && ln -s $main_domain/dhparam.pem $x.dhparam.pem
        done

        # replace dhparam with a new one (this will take some time)
        openssl dhparam -5 -out $main_domain/dhparam.pem 2048

        # if dhparam didn't exist before then create its symblinks
        if [[ $has_dhparam -eq 0 ]]; then
            for x in $alt_domains; do
                ln -s $main_domain/dhparam.pem $x.dhparam.pem
            done
        fi
        ;;
    "unchanged_cert")
        # do nothing
        ;;
    "invalid_challenge")
        echo "Invalid challenge"
        exit 1
        ;;
    "request_failure")
        echo "Request failure"
        exit 1
        ;;
    "exit_hook")
        # do nothing
        ;;
    *)
        echo Unknown hook "${1}"
        exit 1
        ;;
esac

exit 0
