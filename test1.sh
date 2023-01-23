#!/bin/bash

yes|cp -f wcard2.key wcard.key
yes|cp -f wcard2.crt wcard.crt
chmod 775 wcard.*
chown pbsadmin:root wcard.*
cd /root
/etc/init.d/pbsworks-pa stop
/usr/bin/sleep 3
/etc/init.d/pbsworks-pa start
