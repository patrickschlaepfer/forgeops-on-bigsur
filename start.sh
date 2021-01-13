#!/bin/bash

# Minkube starten
minikube start --memory=12288 --cpus=3 --disk-size=40g \
  --vm-driver=virtualbox --bootstrapper kubeadm \
  --kubernetes-version=1.17.4
