#!/bin/bash

echo "create spotmax-maxcloud namespace"
kubectl apply -f maxcloud/namespace.yaml

kubens spotmax-maxcloud

# version 1.10.3
installIstio() {
  echo "install istio begin"
  istioctl install
  echo "install istio end"
}

installKnative() {
  echo 'install knative begin'

  kubectl apply -f knative/serving-crds.yaml
  kubectl apply -f knative/serving-core.yaml
  kubectl apply -l knative.dev/crd-install=true -f knative/istio.yaml
  kubectl apply -f knative/istio.yaml
  kubectl apply -f knative/net-istio.yaml
  kubectl --namespace istio-system get service istio-ingressgateway
  kubectl apply -f knative/serving-hpa.yaml

  until kubectl get cm config-features -n knative-serving ; do date; sleep 3; echo ""; done
  # Feature && Extension
  kubectl patch configmap/config-features -n knative-serving --type merge -p '{"data":{"kubernetes.podspec-affinity":"enabled", "kubernetes.podspec-fieldref":"enabled", "kubernetes.podspec-nodeselector":"enabled", "kubernetes.podspec-tolerations":"enabled"}}'

  echo 'set domainTemplate'
  kubectl patch cm config-network -n knative-serving -p '{"data":{"domainTemplate":"{{.Name}}-{{.Namespace}}.{{.Domain}}"}}'

  # istio auto-injection
  kubectl label namespace knative-serving istio-injection=enabled --overwrite
  echo 'install knative end'
}

installPrometheus() {
  echo "install Prometheus begin"
  kubens spotmax-maxcloud
  kubectl label namespace spotmax-maxcloud istio-injection=disabled --overwrite
  # helm install
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update
  helm install -f prometheus/values.yaml prometheus prometheus-community/kube-prometheus-stack --version 17.0.3

  kubectl create -f prometheus/ServiceMonitor.yaml
  kubectl create -f prometheus/IstioControlPlaneMetrics.yaml
  kubectl create -f prometheus/IsitoDataPlaneMetrics.yaml
  echo "install Prometheus end"
}

installGrafana() {
  echo 'install grafana begin'

  kubectl apply -f maxcloud/grafana.yaml
  # install grafana-proxy
  kubectl apply -f maxcloud/grafana-proxy.yaml

  echo 'install grafana end'
}

installKiali() {
  echo 'install kiali begin'

  helm install \
    --set cr.create=false \
    --set cr.namespace=spotmax-maxcloud \
    --namespace spotmax-maxcloud \
    --repo https://kiali.org/helm-charts \
    --version 1.37.0 \
    kiali-operator \
    kiali-operator

  kubectl apply -f maxcloud/kiali.yaml
  kubectl apply -f maxcloud/kiali-proxy.yaml

  echo 'install kiali end'
}

installJeager() {
  echo 'install jeager begin'

  kubectl apply -f maxcloud/jeager.yaml
  kubectl apply -f maxcloud/jeager-proxy.yaml

  echo 'install jeager end'
}

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
            kubectl apply -f knative/serving-default-domain.yaml
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


ingressGateway=""
getIngressGateway() {
    export INGRESSGATEWAY=knative-ingressgateway

    if kubectl get configmap config-istio -n knative-serving &> /dev/null; then
        export INGRESSGATEWAY=istio-ingressgateway
    fi

    ip=`kubectl get svc $INGRESSGATEWAY --namespace istio-system --output jsonpath="{.status.loadBalancer.ingress[*]['ip']}"`
    if [ -n "$ip" ]; then
            ingressGateway="$ip"
        else
            hostname=`kubectl get svc $INGRESSGATEWAY --namespace istio-system --output jsonpath="{.status.loadBalancer.ingress[*]['hostname']}"`
            ingressGateway="$hostname"
    fi
}


#installIstio
#installKnative
#installPrometheus
#installGrafana
#installKiali
#installJeager
#
#domain

for cmd in "installIstio" "installKnative" "installPrometheus" "installGrafana" "installKiali" "installJeager" "domain"; do
    read -r -p "Run command [$cmd]? [y/n] " input
    case $input in
        [yY][eE][sS]|[yY])
            eval "$cmd"
            ;;
        [nN][oO]|[nN])
            echo "Skipped command [$cmd]"
            ;;
        *)
            echo "Skipped command [$cmd]"
            ;;
    esac
done

while [ -z $ingressGateway ] 
do
    echo "获取getIngressGateway"
    getIngressGateway
    sleep 3
done

echo "**************************************************************************************"
echo ""
echo " 下面为集群网关地址,请配置到域名解析记录，自定义域名才能生效                                  "
echo "$ingressGateway"
echo ""
echo "**************************************************************************************"



############### install knative end

