#!/bin/bash
cp -rfv /altair/pbsworks/pbsaccess/home/config/api_gateway/certs /altair/pbsworks/pbsaccess/home/config/api_gateway/certs-$(date +%Y%m%d%H%M%S)
cd /altair/pbsworks/pbsaccess/home/config/api_gateway/certs/
rm -f wcard[0-9].*
/usr/bin/wget https://hwulvatest1.blob.core.windows.net/arm/wcard2.key > /dev/null 2>&1
/usr/bin/wget https://hwulvatest1.blob.core.windows.net/arm/wcard2.crt > /dev/null 2>&1
yes|cp -f wcard2.key wcard.key
yes|cp -f wcard2.crt wcard.crt
chmod 775 wcard.*
chown pbsadmin:root wcard.*
cd /root
/etc/init.d/pbsworks-pa stop
/usr/bin/sleep 3
/etc/init.d/pbsworks-pa start
