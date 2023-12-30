#!/bin/bash
mkdir -p /etc/aul/
wget https://raw.githubusercontent.com/atulyadavtech/temp/main/usage/va.conf -O /etc/aul/aul-va.conf
wget https://raw.githubusercontent.com/atulyadavtech/temp/main/usage/usage -O /usr/local/bin/usagehrs-new
wget https://raw.githubusercontent.com/atulyadavtech/temp/main/usage/1 -o /tmp/first.sh

bash /tmp/first.sh
