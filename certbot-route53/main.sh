#!/bin/sh
if [ ! -z "$TZPATH" ];
then
    echo "Setting Timezone to $TZPATH"
    cp /usr/share/zoneinfo/$TZPATH /etc/localtime
    date
fi

if [ -z "$STAGING" ];
then
    CERTBOT="certbot"
else
    echo "Staging Mode: No real certs will be generated."
    CERTBOT="certbot --staging"
fi

if [ ! -z "$FORCERENEWAL" ];
then
    FORCERENEWAL="--force-renewal"
fi

if [ ! -z "$EXPAND" ];
then
    EXPAND="--expand"
fi

if [ ! -z "$SERVER" ];
then
    SERVER="--server $SERVER"
fi

$CERTBOT certonly -a "certbot-route53:auth" --non-interactive --text --agree-tos \
    $FORCERENEWAL \
    $EXPAND \
    $SERVER \
    -d $DOMAIN \
    --email $EMAIL \
    --pre-hook "/root/certbot-route53/hook-pre.sh" \
    --renew-hook "/root/certbot-route53/hook-each.sh" \
    --post-hook "/root/certbot-route53/hook-post.sh" \
    "$@"
