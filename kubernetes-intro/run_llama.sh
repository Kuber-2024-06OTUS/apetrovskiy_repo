#!/bin/sh
set -x

NS=homework
PORT=8000
POD_NAME=nginx-pod

cp namespace_ll.yaml namespace.yaml
cp pod_ll.yaml pod.yaml

minikube delete
minikube start

kubectl create -f namespace.yaml
kubectl apply -f account.yaml
kubectl apply -f pod.yaml

#
sleep 1m
#
kubectl get pod "${POD_NAME}" -o wide --namespace "${NS}"
# NAME    READY   STATUS    RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES
# intro   1/1     Running   0          60s   10.244.0.2   minikube   <none>           <none>
POD_IP=$(kubectl get pod "${POD_NAME}" -o wide --namespace "${NS}" -ojsonpath='{.spec.IP}')
PIP=$(kubectl get pod "${POD_NAME}" -o wide --namespace "${NS}" -ojsonpath='{.spec.ip}')
echo $PIP
PN=$(kubectl get pod "${POD_NAME}" -o wide --namespace "${NS}" -ojsonpath='{.spec.name}')
echo $PN
PND=$(kubectl get pod "${POD_NAME}" -o wide --namespace "${NS}" -ojsonpath='{.spec.node}')
echo $PND

kubectl port-forward "pod/${POD_NAME}" -n "${NS}" "${PORT}:${PORT}" &
#
kubectl get po -n "${NS}"
#
kubectl exec "${POD_NAME}" -- curl -s "http://${POD_IP}:${PORT}"
curl http://localhost:${PORT}/${NS}/
curl http://localhost:${PORT}/${NS}/init/
kubectl describe "pod/${POD_NAME}" --namespace="${NS}"
# kubectl delete pod "${POD_NAME}" --namespace "${NS}"

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