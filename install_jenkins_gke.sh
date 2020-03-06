#!/usr/bin/env bash

# https://github.com/helm/charts/blob/master/stable/jenkins/values.yaml

# kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$KUBERNETES_USER_ACCOUNT || true
# kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller || true
# kubectl -n kube-system create sa tiller || true
# helm init --service-account tiller --upgrade || true

# Rolling out Tiller deployment
# kubectl -n kube-system rollout status deployment/tiller-deploy

kubectl create ns jenkins || true

kubectl apply -f jenkins_pvc.yaml

sleep 10

helm upgrade --install jenkins --namespace jenkins -f jenkins_values.yaml --set persistence.existingClaim=jenkins-pvc stable/jenkins

# Rolling out Jenkins deployment
kubectl -n jenkins rollout status deployment/jenkins
