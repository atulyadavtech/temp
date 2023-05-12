#!/bin/bash
/etc/init.d/pbsworks-dc stop;>/var/spool/altaircontrol/pbsa/dc_home/logs/dc/logs/dc.log;echo y | /var/spool/altaircontrol/pbsa/dc_exec/dc/scripts/pbsa-commands/bin/pbsa-dc-data-reset;/etc/init.d/pbsworks-dc start
