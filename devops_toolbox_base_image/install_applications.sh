#!/bin/bash

## This tool allows installation of apt packages with automatic cache cleanup: install_clean

install_clean vim-tiny psmisc unzip jq lsb-core gnupg-agent git

## Install Kubectl
export KUBECTL_VERSION=`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt` && \
        curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
        chmod a+x kubectl && \
        mv kubectl /usr/local/bin/kubectl

## Install Kops
export KOPS_VERSION=`curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4` && \
        curl -LO https://github.com/kubernetes/kops/releases/download/$KOPS_VERSION/kops-linux-amd64 && \
        chmod a+x kops-linux-amd64 && \
        mv kops-linux-amd64 /usr/local/bin/kops

## Install Helm
curl -LO https://git.io/get_helm.sh && chmod 700 get_helm.sh && ./get_helm.sh && \
        rm -f get_helm.sh

## Install Terraform
export TERRAFORM_VERSION=`curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version'` && \
        curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
        unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
        chmod a+x terraform && \
        mv terraform /usr/local/bin/ && \
        rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip
        terraform version

## Install GCloud SDK
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
        echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
        curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
        install_clean google-cloud-sdk

## Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
        install_clean docker-ce docker-ce-cli containerd.io

## Install Python3 and some modules
install_clean python3-setuptools python3-pip && pip3 install requests