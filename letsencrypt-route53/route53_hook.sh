#!/bin/bash
set -e
set -u
set -o pipefail

send_txt_record() {
    local action="$1"
    local zone="$2"
    local name="$3"
    local val="$4"

    aws route53 change-resource-record-sets \
        --hosted-zone-id "$zone" \
        --change-batch file://<(
    cat << EOF
{"Changes": [
    {"Action": "$action", "ResourceRecordSet": {
        "Name": "$name",
        "Type": "TXT",
        "TTL": 300,
        "ResourceRecords": [{ "Value": "\\"$val\\"" }]
    }}
]}
EOF
)
}

get_txt_record() {
    local zone="$1"
    local name="$2"

    [[ ! "$name" =~ .*\.$ ]] && dnsname="${name}."

    aws route53 list-resource-record-sets --hosted-zone-id "$zone" | \
        jq -r ".ResourceRecordSets[] | if .Name == \"$name\" then .ResourceRecords[0].Value else empty end" | \
        sed -e 's|^"\(.*\)"$|\1|'
}

wait_record() {
    local id="$1"
    [[ -z "$id" ]] && return
    aws route53 wait resource-record-sets-changed --id "$id"
}

get_zone_id() {
    local zone="$1"
    aws route53 list-hosted-zones | \
        jq -r "if .HostedZones[0].Name == \"$zone\" then .HostedZones[0].Id else empty end"
}

find_zone_id() {
    local dnsname="$1"

    [[ ! "$dnsname" =~ .*\.$ ]] && dnsname="${dnsname}."

    while [[ -n "$dnsname" ]]; do
        local id=$(get_zone_id "$dnsname")
        if [[ -n "$id" ]]; then
            echo $id
            return 0
        fi
        dnsname="${dnsname#*.}"
    done

    return 1
}

deploy_challenge() {
    local zone_id="$(find_zone_id "$1")" || return
    local name="_acme-challenge.${1}."
    local val="$2"
    local id=$(send_txt_record "UPSERT" "$zone_id" "$name" "$val" | jq -r '.ChangeInfo.Id')
    wait_record "$id"
}

clean_challenge() {
    local zone_id="$(find_zone_id "$1")" || return
    local name="_acme-challenge.${1}."
    local val=$(get_txt_record "$zone_id" "$name")
    local id=$(send_txt_record "DELETE" "$zone_id" "$name" "$val" | jq -r '.ChangeInfo.Id')
    wait_record "$id"
}

echo "HOOK $@"

case "$1" in
    deploy_challenge)
        deploy_challenge "$2" "$4"
        ;;
    clean_challenge)
        clean_challenge "$2"
        ;;
    deploy_cert)
        # do nothing, this is handled by renew_certs
        ;;
    unchanged_cert)
        # do nothing
        ;;
    invalid_challenge)
        echo "Invalid challenge"
        exit 1
        ;;
    request_failure)
        echo "Request failure"
        exit 1
        ;;
    startup_hook)
        # do nothing
        ;;
    exit_hook)
        # do nothing
        ;;
    *)
        echo "Ignoring unknown hook: $1"
        exit 0
        ;;
esac

exit 0
