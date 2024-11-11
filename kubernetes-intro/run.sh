#!/bin/sh

minikube delete

minikube start --driver=kvm2

kubectl apply -f namespace.yaml
kubectl apply -f account.yaml
# --validate=false
kubectl apply -f pod.yaml
