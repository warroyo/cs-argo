#!/bin/bash

export ARGO_IP=$(kubectl get svc -n argocd argocd-server -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
export ARGO_PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
export TMC_URL="https://westtanzuseamericas.tmc.cloud.vmware.com/clusters/$CLUSTER_NAME/$MGMT_CLUSTER/$PROVISIONER/overview"


