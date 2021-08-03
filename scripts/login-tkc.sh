#!/bin/bash
# required env vars:
#   TMC_API_TOKEN
#   PROVISIONER
#   MGMT_CLUSTER
#   CLUSTER_NAME
tmc login --no-configure --name cs-gitops
KUBECTL_PATH=/usr/bin/kubectl
tmc cluster auth admin-kubeconfig get ${CLUSTER_NAME} -p ${PROVISIONER} -m ${MGMT_CLUSTER} > /tmp/${CLUSTER_NAME}-config.yml

export KUBECONFIG="/tmp/${CLUSTER_NAME}-config.yml"