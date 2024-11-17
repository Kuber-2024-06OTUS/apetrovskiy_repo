#!/bin/sh

NS=homework
PORT=8000

cp namespace_ll.yaml namespace.yaml
cp pod_ll.yaml pod.yaml

minikube delete
minikube start

kubectl create -f namespace.yaml
kubectl apply -f account.yaml
kubectl apply -f pod.yaml
kubectl get pod nginx-pod -o wide --namespace "${NS}"
#
sleep 5m
#
kubectl port-forward pod/nginx-pod -n "${NS}" "${PORT}:${PORT}" &
#
kubectl get po -n "${NS}"
#
curl http://localhost:${PORT}/${NS}/
curl http://localhost:${PORT}/${NS}/init/
kubectl delete pod nginx-pod --namespace "${NS}"

# namespace/homework created
# serviceaccount/homework created
# pod/nginx-pod created
# NAME        READY   STATUS    RESTARTS   AGE   IP       NODE     NOMINATED NODE   READINESS GATES
# nginx-pod   0/1     Pending   0          0s    <none>   <none>   <none>           <none>
# NAME        READY   STATUS    RESTARTS   AGE
# nginx-pod   1/1     Running   0          5m
# curl: (7) Failed to connect to localhost port 8000 after 0 ms: Could not connect to server
# curl: (7) Failed to connect to localhost port 8000 after 0 ms: Could not connect to server
# Forwarding from 127.0.0.1:8000 -> 8000
# Forwarding from [::1]:8000 -> 8000
# pod "nginx-pod" deleted