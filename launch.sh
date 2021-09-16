#!/bin/bash

echo "Starting cluster"
minikube start
echo "Export docker configuration"
source <(echo $(minikube -p localdev docker-env))
echo "Start coding"
tilt up

trap ctrl_c INT

function ctrl_c() {
  tilt down
}