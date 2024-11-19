#!/bin/sh
set -x

NS=homework
PORT=8000
POD_NAME=intro

cp namespace_mine.yaml namespace.yaml
cp pod_mine.yaml pod.yaml

# initializing minikube
minikube delete
minikube start

# loading manifests and setting the context
kubectl apply -f namespace.yaml
kubectl apply -f account.yaml
kubectl apply -f pod.yaml
kubectl config set-context --current --namespace="${NS}"

sleep 1m

# checking the pod visually
kubectl get pod "${POD_NAME}" -o wide

kubectl port-forward "${POD_NAME}" "${PORT}:${PORT}" &

# checking status of the pod containers
kubectl get events | grep 'Started container init'
kubectl get events | grep 'Started container web'

# loading the index.html file that was created in the /init folder
# and is available in the /homework folder
POD_IP=$(kubectl get pod "${POD_NAME}" -o wide -ojsonpath='{.status.podIP}')
kubectl exec "${POD_NAME}" -- curl -s "http://${POD_IP}:${PORT}"
kubectl cp "${POD_NAME}:/homework/index.html" ./index1.html

kubectl delete pod "${POD_NAME}"

kubectl get events | grep FailedPreStopHook
kubectl get events | grep PreStopHook
