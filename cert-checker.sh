#!/bin/bash -e

for DOMAIN in `cat domains.txt`; do
    IFS="=" CERTDATE=(`echo | openssl s_client -connect $DOMAIN:443 2>/dev/null | openssl x509  -noout -enddate`)
    ENDDATE=${CERTDATE[1]}

    IFS=$'\n' CHAIN=(`echo -n | openssl s_client -connect $DOMAIN:443 2>/dev/null | sed -ne '/Certificate chain/,/---/p'`)
    ROOT=${CHAIN[-2]}

    printf "$DOMAIN; $ENDDATE; $ROOT\n"
done
