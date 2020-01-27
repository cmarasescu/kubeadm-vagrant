# Kuberntes cluster setup with vagrant, VirtualBox and kubeadm

## Usage

### Bring the cluster up
```
vagrant up master
vagrant up node01
vagrant up node02
```

### Manage cluster with kubectl
```
export KUBECONFIG=$(pwd)/src/output/kubeconfig.yaml
kubectl cluster-info
```
or login into the master node:
```
vagrant ssh master
kubectl cluster-info
kns <my-fancy-namespace> # change the default namespace in kubeconfig
kubectl get <my-fancy-object>
```

### Manage cluster with kube-dashboard
```
Browse to https://192.168.100.100:31001
Use token generated in src/output/cluster_admin_token.txt
```

### Running one node cluster

If you want to run only the master node and be able to schedule Pods on it, remove the taint from the master:
```
kubectl taint nodes master node-role.kubernetes.io/master-
```
### Update and upload to Vagrant cloud the K8s-base box
- connect to https://app.vagrantup.com => select you account => Security => Generate token => copy the token locally
cd ./src/template
cat %token% > ./.vagrant_token
- update pack.sh to reflect your vagrant account (the box will be uploaded to app.vagrantup.com -> cmarasescu/k8s-base. If you intend to upload it under your account, change cmarasescu with your own vagrant account)
- at this point you are ready to pack and release publicly the box:
./pack.sh


Enjoy
