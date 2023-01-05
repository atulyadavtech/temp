##RAS Rule
export COMPARTMENT_ID=$(cat /root/ras-aul/comp.out)
export VCN_ID=$(cat /root/ras-aul/vcn.out)
export RAS=$(oci network security-list list  --compartment-id=$COMPARTMENT_ID --vcn-id=$VCN_ID --output table --query 'data [*].{Name:"display-name", id:id}' | grep -i aul-ras-rule | cut -d "|" -f3)
echo $RAS > /root/ras-aul/ras1.out
