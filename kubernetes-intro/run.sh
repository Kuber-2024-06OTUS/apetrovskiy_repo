#!/bin/sh

NS=homework
PORT=8000

cp namespace_mine.yaml namespace.yaml
cp pod_mine.yaml pod.yaml

minikube delete

minikube start # --driver=kvm2

kubectl apply -f namespace.yaml
kubectl apply -f account.yaml
kubectl apply -f pod.yaml

# sleep 2m
kubectl get pod intro -o wide --namespace "${NS}"
#
sleep 5m
#
kubectl port-forward intro -n "${NS}" "${PORT}:${PORT}" &
#
kubectl get po -n "${NS}"
#
curl "http://localhost:${PORT}/${NS}/"
curl "http://localhost:${PORT}/${NS}/init/"
