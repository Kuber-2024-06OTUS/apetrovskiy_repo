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

sleep 1m
#
kubectl get pod "${POD_NAME}" -o wide --namespace "${NS}"
# NAME    READY   STATUS    RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES
# intro   1/1     Running   0          60s   10.244.0.2   minikube   <none>           <none>
POD_IP=$(kubectl get pod "${POD_NAME}" -o wide --namespace "${NS}" -ojsonpath='{.status.podIP}')
#
kubectl port-forward "${POD_NAME}" -n "${NS}" "${PORT}:${PORT}" &
#
kubectl get po -n "${NS}"
#
kubectl cluster-info
#
kubectl exec "${POD_NAME}" -- curl -s "http://${POD_IP}:${PORT}"
curl "http://localhost:${PORT}/${NS}/"
curl "http://localhost:${PORT}/${NS}/init/"
kubectl describe "pod/${POD_NAME}" --namespace="${NS}"

kubectl delete pod "${POD_NAME}" --namespace "${NS}"
