#!/bin/bash

#requires 2 env vars
# DOCKERHUB_PASS
# DOCKERHUB_USER

#add namespace and create a secret for dockerhub since it wont be able to pull the redis image due to rate limiting
kubectl create ns argocd
kubectl create secret -n argocd docker-registry dockerhub --docker-server=https://index.docker.io/v2/ --docker-username=$DOCKERHUB_USER --docker-password=$DOCKERHUB_PASS

#running this twice is a workaround due to the lab being slow
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml -v 10
kubectl patch serviceaccount argocd-redis -p '{"imagePullSecrets": [{"name": "dockerhub"}]}' -n argocd
#patch to get a loadbalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl scale deployment argocd-redis --replicas 0 -n argocd
kubectl scale deployment argocd-redis --replicas 1 -n argocd
#apply initial app
kubectl apply -f ../argo/initial-app.yml