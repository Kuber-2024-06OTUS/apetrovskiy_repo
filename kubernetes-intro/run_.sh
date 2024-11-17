#!/bin/sh

minikube delete

minikube start --driver=kvm2

kubectl apply -f namespace.yaml
kubectl apply -f account.yaml
kubectl apply -f pod.yaml

# kubectl run demo --image=YOUR_DOCKER_ID/myhello --port=9999 --labels app=demo
# deployment.apps "demo" created

# kubectl port-forward deploy/demo 9999:8888
# Forwarding from 127.0.0.1:9999 -> 8888
# Forwarding from [::1]:9999 -> 8888
