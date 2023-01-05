export COMPARTMENT_ID=$(cat /root/.scripts/compid.out)
export VCN_ID=$(oci network vcn list --compartment-id="$COMPARTMENT_ID" | grep  vcn | head -n 1 | cut -d '"' -f4)
export SL=$(oci network security-list list  --compartment-id=$COMPARTMENT_ID --vcn-id=$VCN_ID --output table --query 'data [*].{Name:"display-name", id:id}' | grep -i aul-ras-rule | head -n 1 |  cut -d '|' -f3)
echo $SL > /root/ras-aul/sl.out
