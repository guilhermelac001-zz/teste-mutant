#!/usr/bin/env bash

#gcloud container clusters get-credentials $CLUSTER_NAME --zone $CLUSTER_ZONE --project $PROJECT_ID

helm del --purge jenkins

kubectl delete -f jenkins/jenkins_pvc.yaml

kubectl delete -f jenkins/jenkins_ingress.yaml

kubectl delete ns jenkins


