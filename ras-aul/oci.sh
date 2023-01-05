export SUBNET=$(cat /root/ras-aul/sb1.out)
oci network subnet update --subnet-id $SUBNET --security-list-ids file:///root/ras-aul/final.json --force
oci network subnet get --subnet-id $SUBNET > /root/ras-aul/final-subnet
