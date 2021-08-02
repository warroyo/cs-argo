#!/bin/bash
export PROVISIONER=$(yq eval -j ${CLUSTER_YAML} | jq -r '.fullName.provisionerName')
export CLUSTER_NAME=$(yq eval -j ${CLUSTER_YAML} | jq -r '.fullName.name')
export MGMT_CLUSTER=$(yq eval -j ${CLUSTER_YAML} | jq -r '.fullName.managementClusterName')