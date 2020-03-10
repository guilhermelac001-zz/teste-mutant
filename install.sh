 export PROJECT=mutantproject
 export CLUSTER=cluster-2
 export ZONE=us-east4-a	

# ##create cluster

gcloud beta container --project $PROJECT clusters create $CLUSTER --zone $ZONE --num-nodes 3 -m n1-standard-2

gcloud container clusters get-credentials $CLUSTER --zone $ZONE --project $PROJECT

##install helm

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

helm init

kubectl create serviceaccount --namespace kube-system tiller

kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

kubectl patch deploy --namespace kube-system tiller-deploy --patch '{"spec": {"template": {"spec": {"serviceAccount": "tiller"} } } }'

##install istio

curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.5.0 sh -

helm repo add istio.io https://storage.googleapis.com/istio-release/releases/1.5.0/charts/

helm repo update

kubectl create namespace istio-system

cd istio-1.5.0

kubectl apply -f install/kubernetes/helm/helm-service-account.yaml

helm init --service-account tillers

sleep 15

helm install install/kubernetes/helm/istio-init --name istio-init --namespace istio-system

kubectl -n istio-system wait --for=condition=complete job --all

helm install install/kubernetes/helm/istio --name istio --namespace istio-system

sleep 15

kubectl label namespace default istio-injection=enabled

cd ..

#install application on cluster

cd CI/node-helm

helm install node-chart --name node-chart

#build and push devops-toolbox and install jenkins on gk8s cluster

cd .. 

cd ..

cd devops_toolbox_base_image

docker build -t gcr.io/$PROJECT/devops-toolbox:latest .

docker push gcr.io/$PROJECT/devops-toolbox:latest

cd ..

sh install_jenkins_gke.sh

#install grafana and prometheus

# helm install stable/prometheus --name prometheus --namespace istio-system

# helm install stable/grafana --name grafana --namespace istio-system

