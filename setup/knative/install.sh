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

# set domain
diyDomain() {
    while [ -z "$domain" ]; do
        echo ""
        echo "域名格式参照：\"spotmaxtech.com\""
        read -p "请输入自定义域名：" domain
    done
    kubectl patch configmap/config-domain -n knative-serving --type merge -p "{\"data\":{\"$domain\":\"\"}}"
    if [ $? -ne 0 ]; then
        echo "设置域名失败，请重检查输入正确域名后重试"
        domain=""
        diyDomain
    fi

    echo "domain: $domain"
}

domain() {
    echo "如果使用默认域名请输入\"Y\""
    echo "如果需要自定义域名请输入\"N\""
    echo ""
    read -r -p "use default domain? [Y/n] " input
    case $input in
        [yY][eE][sS]|[yY])
            # default-domain
            echo "默认域名"
            kubectl apply -f $knative_dir/serving-default-domain.yaml
            ;;
        [nN][oO]|[nN])
            diyDomain
            ;;
        *)
            echo "Invalid input..."
            domain
            ;;
    esac
}

domain