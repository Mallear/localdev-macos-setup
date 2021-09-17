Minikube localdev setup
---

Scripts is this repo are based on documentation and blog posts:
- https://itnext.io/goodbye-docker-desktop-hello-minikube-3649f2a1c469
- https://minikube.sigs.k8s.io/docs/handbook/addons/ingress-dns/#mac-os

# Install
`./install.sh` script:
- install all dependencies:
  - hyperkit
  - docker engine and cli
  - kubectl
  - docker-credential-helper for registry authentication
  - tilt.dev
  - minikube (need sudo access)
- configure minikube
- install and configure addons
  - ingress
  - ingress-dns
  - metallb
  - metrics-server
  - dashboard
- configure MacOS DNS resolver for .localdev domain (need sudo access)

# Launch development context
`./launch.sh` script:
- start minikube cluster
- load minikube docker environment
- launch tilt

Once Tilt is launched, the app should be available at tilt-demo.localdev

# Using Docker
To use Docker from anywhere on your machine:
```bash
$ minikube -p localdev docker-env | source
$ docker info
```
## Volumes mount

To mount a volume like you did with docker-compose project:

```bash
$ minikube mount ./:$(pwd)
$ docker-compose up
```

# Keeping containers

Running `minikube stop/start` will delete all container not linked to kubernetes or addons. To avoid this, run `minikube pause/unpause.