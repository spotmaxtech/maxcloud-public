#!/bib/bash

namespace="spotmax-maxcloud"

####导入证书
kubectl create secret generic elastic-certificates --from-file=elastic-certificates.p12 -n $namespace 
kubectl create secret generic elastic-certificate-pem --from-file=elastic-certificate.pem  -n $namespace
kubectl create secret generic elastic-certificate-crt --from-file=elastic-certificate.crt  -n $namespace

####设置es用户名和密码
kubectl create secret  generic elastic-credentials --from-literal=username=elastic --from-literal=password=elastic -n $namespace

####安装
helm repo add elastic https://helm.elastic.co
helm repo update
helm install elasticsearch -f values.yaml  elastic/elasticsearch  -n $namespace
