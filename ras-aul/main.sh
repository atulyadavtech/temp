##default Rule
export COMPARTMENT_ID=$(cat /root/ras-aul/comp.out)
export VCN_ID=$(cat /root/ras-aul/vcn.out)
export MAIN=$(oci network subnet list --compartment-id=$COMPARTMENT_ID --vcn-id=$VCN_ID | grep -A11  public_subnet | tail -n 1 | cut -d '"' -f2)
echo $MAIN > /root/ras-aul/main.out
