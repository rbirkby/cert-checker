#!/bin/bash -e

for DOMAIN in `cat domains.txt`; do
    IFS="=" CERTDATE=(`echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -enddate`)
    ENDDATE=${CERTDATE[1]}

    IFS=$'\n' CHAIN=(`echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | sed -ne '/Certificate chain/,/---/p'`)
    ROOT=${CHAIN[-2]}

    IFS="=" FINGERPRINT=(`echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -fingerprint -sha256`)
    SHA256THUMBPRINT=${FINGERPRINT[1]}
    THUMBPRINT=`echo $SHA256THUMBPRINT | sed -r 's/://g'`

    SAN=`echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -text | grep -A1 'Subject Alternative Name' | tail -n1`

    printf "$DOMAIN; $ENDDATE; $ROOT; $THUMBPRINT; $SAN\n"
done
