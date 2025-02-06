export COMPARTMENT_ID=$(cat /root/.scripts/compid.out)
/usr/bin/oci iam compartment update  --compartment-id $COMPARTMENT_ID --freeform-tags '{"isProduction": "activeFeb2025"}' --force
