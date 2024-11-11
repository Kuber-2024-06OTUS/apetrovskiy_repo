#!/bin/sh

minikube delete

minikube start --driver=kvm2

kubectl apply -f namespace.yaml
kubectl apply -f account.yaml
kubectl apply -f pod.yaml
