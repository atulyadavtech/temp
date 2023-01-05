##Public Subnet
export COMPARTMENT_ID=$(cat /root/ras-aul/comp.out)
export VCN_ID=$(cat /root/ras-aul/vcn.out)
export SB=$(oci network subnet list --compartment-id=$COMPARTMENT_ID --vcn-id=$VCN_ID | grep -A3  public_subnet | tail -n 1 | cut -d '"' -f4)
echo $SB > /root/ras-aul/sb1.out
