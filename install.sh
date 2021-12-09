#!/bin/bash

brew update

echo "Installing dependencies"
brew install hyperkit
brew install docker
brew install kubectl
brew install docker-credential-helper
brew install tilt-dev/tap/tilt

echo "Download minikube" # Version available using homebrew (1.23.0) has a configuration issue with ingress addon
curl -LO https://storage.googleapis.com/minikube/releases/v1.22.0/minikube-darwin-amd64
echo "Install minikube, need sudo access"
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
rm minikube-darwin-amd64

minikube config set cpus 3
minikube config set memory 6g

echo "Starting cluster"
minikube start --nodes 2 --kubernetes-version=v1.21.5 --driver=hyperkit --container-runtime=docker -p localdev

minikube profile localdev
minikube_ip=$(minikube ip)

echo "Enabling addons"
minikube addons enable ingress
minikube addons enable ingress-dns
minikube addons enable metallb
minikube addons enable metrics-server
minikube addons enable dashboard

METALLB_IP_PREFIX_RANGE=$(minikube ip | sed -r 's/(.*)./\1/')

echo "Configure metallb"
cat ~/.minikube/profiles/localdev/config.json  \
| jq '.KubernetesConfig.LoadBalancerStartIP="'${minikube_ip}'"' \
| jq '.KubernetesConfig.LoadBalancerEndIP="'${METALLB_IP_PREFIX_RANGE}20'"' \
> ~/.minikube/profiles/localdev/config.json.tmp && mv ~/.minikube/profiles/localdev/config.json.tmp ~/.minikube/profiles/localdev/config.json

minikube addons configure metallb


echo "Configure DNS resolver, need sudo access"

sudo mkdir -p /etc/resolver

echo -e "domain localdev\nnameserver $minikube_ip\nsearch_order 1\ntimeout 5" | sudo tee /etc/resolver/minikube-localdev-localdev
