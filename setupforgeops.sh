#!/bin/bash

# Installiere Abhängigkeiten
brew install --cask docker
brew install kubernetes-cli
brew install skaffold
brew install kustomize
brew install kubectx
brew install --cask virtualbox
brew install minikube
brew install k9s

# Minkube starten
minikube start --memory=12288 --cpus=3 --disk-size=40g \
  --vm-driver=virtualbox --bootstrapper kubeadm \
  --kubernetes-version=1.17.4

# Ingress Addons enablen
minikube addons enable ingress

# Lokale Docker Registry enablen
minikube ssh sudo ip link set docker0 promisc on

# Namespace erstellen
kubectl create namespace my-namespace

# Namespace wechseln
kubens my-namespace