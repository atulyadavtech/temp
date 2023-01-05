export SL=$(cat /root/ras-aul/s2.out)
oci network security-list delete --security-list-id $SL
