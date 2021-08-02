#!/bin/bash

export TMC_API_TOKEN=$1
tmc login --no-configure --name cs-gitops


RESULT=$(tmc cluster create -f $CLUSTER_YAML 2>&1)
CREATE_ERROR=$?

if [ $CREATE_ERROR -eq 1 ] && [[ "${RESULT}" == *"AlreadyExists"* ]]; then
echo "cluster exists updating..."
MGMT=$(yq e '.fullName.managementClusterName' $CLUSTER_YAML)
PROV=$(yq e '.fullName.provisionerName' $CLUSTER_YAML)

tmc cluster get $CLUSTER_NAME -p $PROV -m $MGMT | ytt -f rebase.yml -f - -f $CLUSTER_YAML  > cluster-update.yaml

tmc cluster update -f cluster-update.yaml

rm cluster-update.yaml

elif [ $CREATE_ERROR -eq 1 ]; then
echo "there was an error"
echo $RESULT
exit 1

else
echo "creating cluster.."
echo $RESULT
exit 0
fi