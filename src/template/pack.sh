#!/usr/bin/env bash
echo -e "\nIn order to package our box, we first need to start the template"
for i in $(vagrant status | grep '(virtualbox)$' | grep 'not created' | awk '{print $1}')
do
        echo "Starting the Vagrant box"
        vagrant up "$i"
done

echo -e "\n\nPackage the box locally"
rm -rf output/k8s-base.box 2> /dev/null
vagrant package --output output/k8s-base.box 
vagrant box remove cmarasescu/k8s-base  2> /dev/null
vagrant box add output/k8s-base.box --name cmarasescu/k8s-base
echo -e "\n\nUpload the packaged image to Vagrant cloud to make it available to the community"
if [ ! -f .vagrant_token ]; then
  echo "Critical: in order to authenticate to Vagrant cloud to upload your box, you need to connect to Vagrant, generate a token and paste your Vagrant token in file \".vagrant_token\""
  exit 2
fi
vagrant_token=$(cat ./.vagrant_token)
vagrant cloud auth login --check
vagrant cloud auth login --token $vagrant_token

vagrant cloud publish cmarasescu/k8s-base 1.15.1 virtualbox output/k8s-base.box -d "K8s base box using Kubeadm v1.15.1 + Ubuntu 18.04.3 LTS" --version-description "ubuntu + kubeadm v1.15.1" --release --short-description "K8s base box using Kubeadm v1.15.1 + Ubuntu 18.04.3 LTS" --force

