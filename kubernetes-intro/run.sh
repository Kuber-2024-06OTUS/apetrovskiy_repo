#!/bin/sh
set -x

NS=homework
PORT=8000
POD_NAME=intro

cp namespace_mine.yaml namespace.yaml
cp pod_mine.yaml pod.yaml

minikube delete

minikube start # --driver=kvm2

kubectl apply -f namespace.yaml
kubectl apply -f account.yaml
kubectl apply -f pod.yaml

# sleep 2m
kubectl get pod "${POD_NAME}" -o wide --namespace "${NS}"
#
sleep 1m
#
kubectl port-forward "${POD_NAME}" -n "${NS}" "${PORT}:${PORT}" &
#
kubectl get po -n "${NS}"
#
kubectl describe "pod/${POD_NAME}" --namespace="${NS}"
curl "http://localhost:${PORT}/${NS}/"
curl "http://localhost:${PORT}/${NS}/init/"
kubectl describe "pod/${POD_NAME}" --namespace="${NS}"
