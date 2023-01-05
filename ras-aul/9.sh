export COMPARTMENT_ID=$(cat /root/.scripts/compid.out)
export VCN_ID=$(oci network vcn list --compartment-id="$COMPARTMENT_ID" | grep  vcn | head -n 1 | cut -d '"' -f4)
echo  $COMPARTMENT_ID >> /root/ras-aul/comp.out
echo $VCN_ID > /root/ras-aul/vcn.out
export SB=$(oci network subnet list --compartment-id=$COMPARTMENT_ID --vcn-id=$VCN_ID | grep -A11  public_subnet)
echo $SB > /root/ras-aul/sb1.out
