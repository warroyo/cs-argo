#!/bin/bash
# required env vars:
#   TMC_API_TOKEN
#   CLUSTER_YAML
#   PROVISIONER
#   MGMT_CLUSTER
#
script_full_path=$(dirname "$0")
tmc login --no-configure --name cs-gitops


RESULT=$(tmc cluster create -f $CLUSTER_YAML 2>&1)
CREATE_ERROR=$?

if [ $CREATE_ERROR -eq 1 ] && [[ "${RESULT}" == *"AlreadyExists"* ]]; then
echo "cluster exists updating..."

tmc cluster get $CLUSTER_NAME -p $PROVISIONER -m $MGMT_CLUSTER | ytt -f $script_full_path/../manifests/rebase.yml -f - -f $CLUSTER_YAML  > cluster-update.yaml

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