#!/bin/bash
# required env vars:
#   TMC_API_TOKEN
#   PROVISIONER
#   MGMT_CLUSTER
#   WAVEFRONT_TOKEN
#   CLUSTER_NAME


echo "enabling TO on ${CLUSTER_NAME}"


 
cat << EOF > TO.json
{
    "full_name": {
        "provisionerName": "${PROVISIONER}",
        "managementClusterName": "${MGMT_CLUSTER}",
        "clusterName": "${CLUSTER_NAME}",
        "name": "tanzu-observability-saas"
    },
    "spec": {
        "configurations": {
            "url": "https://vmware.wavefront.com"
        },
        "secrets": {
            "token": "${WAVEFRONT_TOKEN}"
        }
    }
}

EOF



RESULT=$(tmc cluster integration create -f TO.json 2>&1)
CREATE_ERROR=$?
rm TO.json
if [ $CREATE_ERROR -eq 1 ] && [[ "${RESULT}" == *"AlreadyExists"* ]]; then
echo "cluster already enabled for TO..."
exit 0

elif [ $CREATE_ERROR -eq 1 ]; then
echo "there was an error"
echo $RESULT
exit 1

else
echo "enabling TO.."
echo $RESULT
exit 0
fi