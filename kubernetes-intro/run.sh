#!/bin/sh
set +x

NS=homework
PORT=8000
POD_NAME=intro
PAGE_FILE=index.html
PASSED=PASSED
FAILED=FAILED

rm -f "${PAGE_FILE}"

# initializing minikube
minikube delete
minikube start

# loading manifests and setting the context
echo "=== Loading manifests... ==="
kubectl apply -f namespace.yaml
kubectl apply -f account.yaml
kubectl apply -f pod.yaml
kubectl config set-context --current --namespace="${NS}"

echo "=== Waiting one minute for the pod being run... ==="
sleep 1m

# checking the pod visually
kubectl get pod "${POD_NAME}" -o wide

# seemingly does not work
kubectl port-forward "${POD_NAME}" "${PORT}:${PORT}" &

# checking status of the pod containers
echo "=== Checking that containers have started... ==="
IS_INIT_STARTED=$(kubectl get events | grep 'Started container init')
IS_WEB_STARTED=$(kubectl get events | grep 'Started container web')
[ ! -z "${IS_INIT_STARTED}" ] && echo "init started - ${PASSED}" || echo "init started - ${FAILED}"
[ ! -z "${IS_WEB_STARTED}" ] && echo "web started - ${PASSED}" || echo "web started - ${FAILED}"

# loading the index.html file that was created in the /init folder
# and is available in the /homework folder
echo "=== Checking availability of the pod and existense of ${PAGE_FILE}... ==="
POD_IP=$(kubectl get pod "${POD_NAME}" -o wide -ojsonpath='{.status.podIP}')
kubectl exec "${POD_NAME}" -- curl -s "http://${POD_IP}:${PORT}"
IS_PORT_SET=$(kubectl get pod "${POD_NAME}" -o wide -ojsonpath='{.status.podPort}')
[ "${PORT}" = "${IS_PORT_SET}" ] && echo "pod port set to ${PORT} - ${PASSED}" || echo "pod port set to ${PORT}  - ${FAILED}"
kubectl cp "${POD_NAME}:homework/${PAGE_FILE}" "./${PAGE_FILE}"
[ -e "${PAGE_FILE}" ] && echo "${PAGE_FILE} found - ${PASSED}" || echo "${PAGE_FILE} found - ${FAILED}"

kubectl delete pod "${POD_NAME}"

FAILED_PRE_STOP_HOOK=$(kubectl get events | grep FailedPreStopHook)
kubectl get events | grep PreStopHook
[ -z "${FAILED_PRE_STOP_HOOK}" ] && echo "preStop hook no failure - ${PASSED}" || echo "preStop hook no failure - ${FAILED}"
