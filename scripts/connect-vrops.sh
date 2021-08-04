#!/bin/bash
#required env vars
# VROPS_API_TOKEN
# CLUSTER_NAME
# CLUSTER_URL
# CLUSTER_CERT
# CLIENT_CERT
# CLIENT_KEY
# PROM_URL

PROM_IP=$(kubectl get svc -n monitoring  prometheus-kube-prometheus-prometheus -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
export PROM_URL="http://${PROM_IP}:9090"
export CLUSTER_CERT=$(kubectl config view --minify --raw --output 'jsonpath={..cluster.certificate-authority-data}')
export CLIENT_CERT=$(kubectl config view --minify --raw --output 'jsonpath={..user.client-certificate-data}')
export CLIENT_KEY=$(kubectl config view --minify --raw --output 'jsonpath={..user.client-key-data}')
export CLUSTER_URL=$(kubectl config view --minify --raw --output 'jsonpath={..cluster.server}')


#get access token for vrops cloud
export ACCESS_TOKEN=$(curl -s -X POST https://console.cloud.vmware.com/csp/gateway/am/api/auth/api-tokens/authorize\?refresh_token\=$VROPS_API_TOKEN | jq -r '.access_token')

curl  -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: CSPToken ${ACCESS_TOKEN}" -XPOST https://www.mgmt.cloud.vmware.com/vrops-cloud/suite-api/api/adapters --data-binary @- >patch.json << EOF
{
  "name" : "$CLUSTER_NAME",
  "description" : "k8s cluster instances",
  "collectorId" : "5",
  "adapterKindKey" : "KubernetesAdapter",
  "resourceIdentifiers" : [ 
    {
      "name" : "CADVISOR_SERVICE",
      "value" : "PROMETHEUS"
    }, 
    {
      "name" : "ENABLE_PROMETHEUS_METRICS_LABELS",
      "value" : "true"
    }, 
    {
      "name" : "K8S_MASTERURL",
      "value" : "$CLUSTER_URL"
    } 
    {
      "name" : "PROMETHEUS_METRIC_LABELS_TO_EXCLUDE",
      "value" : ""
    }
  ],
  "credential" : {
    "id" : null,
    "name" : "$CLUSTER_NAME",
    "adapterKindKey" : "KubernetesAdapter",
    "credentialKindKey" : "KUBE_CREDENTIALS_CERT",
    "fields" : [ 
      {
        "name" : "CERT_AUTHORITY_DATA",
        "value" : "$CLUSTER_CERT"
      }, 
      {
        "name" : "CLIENT_CERT_DATA",
        "value" : "$CLIENT_CERT"
      },
       {
        "name" : "CLIENT_KEY_DATA",
        "value" : "$CLIENT_KEY"
      },
      {
        "name" : "PROMETHEUS_SERVER",
        "value" : "$PROM_URL"
      }  

    ],
  },
}
EOF


export ADAPTER_UUID=$(cat patch.json| jq -r '.id')
echo $ADAPTER_UUID

curl -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: CSPToken ${ACCESS_TOKEN}" -XPATCH https://www.mgmt.cloud.vmware.com/vrops-cloud/suite-api/api/adapters -d @patch.json

curl -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: CSPToken ${ACCESS_TOKEN}" -XPUT https://www.mgmt.cloud.vmware.com/vrops-cloud/suite-api/api/adapters/$ADAPTER_UUID/monitoringstate/start




