#!/bin/bash
export COMPARTMENT_ID=$(cat /root/.scripts/compid.out)
export VCN_ID=$(oci network vcn list --compartment-id="$COMPARTMENT_ID" | grep  vcn | head -n 1 | cut -d '"' -f4)
export SB=$(oci network subnet list --compartment-id=$COMPARTMENT_ID --vcn-id=$VCN_ID | grep -A11  public_subnet | tail -n 1 | cut -d '"' -f2)
#oci network security-list create --compartment-id $COMPARTMENT_ID --vcn-id $VCN_ID --display-name aul-ras-rule --ingress-security-rules file:///root/ras-aul/ingress-aul-ras.json  --egress-security-rules file:///root/ras-aul/egress-aul-ras.json
oci network security-list list --compartment-id=$COMPARTMENT_ID --vcn-id=$VCN_ID --output table --query 'data [*].{Name:"display-name", id:id}'
