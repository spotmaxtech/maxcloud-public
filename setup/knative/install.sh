#!/usr/bin/env bash

function download() {
  public_dir=/tmp/maxcloud_public
  if [ -d "$public_dir" ]; then
    cd $public_dir && git pull
  else
    git clone https://github.com/spotmaxtech/maxcloud_public.git $public_dir
  fi
}

download

knative_dir=$public_dir/setup/knative

echo 'install knative begin'
kubectl apply -f $knative_dir/serving-crds.yaml
kubectl apply -f $knative_dir/serving-core.yaml
kubectl apply -l knative.dev/crd-install=true -f $knative_dir/istio.yaml
kubectl apply -f $knative_dir/istio.yaml
kubectl apply -f $knative_dir/net-istio.yaml
kubectl --namespace istio-system get service istio-ingressgateway
kubectl apply -f $knative_dir/serving-hpa.yaml

until kubectl get cm config-features -n knative-serving ; do date; sleep 3; echo ""; done
# Feature && Extension
kubectl patch configmap/config-features -n knative-serving --type merge -p '{"data":{"kubernetes.podspec-affinity":"enabled", "kubernetes.podspec-fieldref":"enabled", "kubernetes.podspec-nodeselector":"enabled", "kubernetes.podspec-tolerations":"enabled"}}'

echo 'set domainTemplate'
kubectl patch cm config-network -n knative-serving -p '{"data":{"domainTemplate":"{{.Name}}-{{.Namespace}}.{{.Domain}}"}}'

# istio auto-injection
kubectl label namespace knative-serving istio-injection=enabled --overwrite
echo 'install knative end'
