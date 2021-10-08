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

As minikube nginx ingress addon start with a ClusterIP service, it need to be patch and set as a LoadBalancer service to accept traffic and to get an IP from metalLB. For that, two solutions:
- `kubectl patch service ingress-nginx-controller --type=merge -p "spec: {type: LoadBalancer}" -n ingress-nginx` as used in the `launch.sh` script
- Redefine the service in the `kubernetes.yaml` file:
  ```yaml
  ---
  apiVersion: v1
  kind: Service
  metadata:
    annotations:
    labels:
      app.kubernetes.io/name: ingress-nginx
      app.kubernetes.io/instance: ingress-nginx
      app.kubernetes.io/component: controller
    name: ingress-nginx-controller
    namespace: ingress-nginx
  spec:
    type: LoadBalancer
    ports:
      - name: http
        port: 80
        protocol: TCP
        targetPort: http
      - name: https
        port: 443
        protocol: TCP
        targetPort: https
    selector:
      app.kubernetes.io/name: ingress-nginx
      app.kubernetes.io/instance: ingress-nginx
      app.kubernetes.io/component: controller
    ```

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