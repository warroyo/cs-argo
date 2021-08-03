#!/bin/bash
# required env vars:
#   TMC_API_TOKEN
#   PROVISIONER
#   MGMT_CLUSTER
#

currentstatus=$(tmc cluster get ${CLUSTER_NAME} -m ${MGMT_CLUSTER} -p ${PROVISIONER} -o json | jq -r '.status.phase')
statusdone="READY"
while [ "$currentstatus" != "$statusdone" ]
do
  echo "Still Building Cluster"
  sleep 20
  currentstatus=$(tmc cluster get ${CLUSTER_NAME} -m ${MGMT_CLUSTER} -p ${PROVISIONER} -o json | jq -r '.status.phase')
  echo "current status: ${currentstatus}"
done

echo "Cluster Build Complete"