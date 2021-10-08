#!/bin/bash

echo "Starting cluster"
minikube start
# Needed to tell metallb to create a loadbalancer and redirect traffic to nginx
kubectl patch service ingress-nginx-controller --type=merge -p "spec: {type: LoadBalancer}" -n ingress-nginx
echo "Export docker configuration"
source <(echo $(minikube -p localdev docker-env))
echo "Start coding"
tilt up

trap ctrl_c INT

function ctrl_c() {
  tilt down
}