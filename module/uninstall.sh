#!/bin/bash

kubens spotmax-maxcloud

## Uninstall knative
kubectl delete -f knative/serving-crds.yaml
kubectl delete -f knative/serving-core.yaml
kubectl delete -l knative.dev/crd-install=true -f knative/istio.yaml
kubectl delete -f knative/istio.yaml
kubectl delete -f knative/net-istio.yaml
kubectl --namespace istio-system get service istio-ingressgateway
kubectl delete -f knative/serving-hpa.yaml

# hpa
kubectl delete -f knative/serving-hpa.yaml

kubectl delete KnativeServing knative-serving -n knative-serving
kubectl delete -f knative_operator/operator.yaml
kubectl delete -f knative_operator/knative-serving.yaml

kubectl delete ns knative-serving


## Uninstall chart
kubectl delete -f prometheus/IsitoDataPlaneMetrics.yaml
kubectl delete -f prometheus/IstioControlPlaneMetrics.yaml
kubectl delete -f prometheus/ServiceMonitor.yaml

istioctl manifest generate | kubectl delete -f -

helm uninstall prometheus
kubectl delete job prometheus-kube-prometheus-admission-create



## Delete CRD
kubectl delete crd alertmanagerconfigs.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
kubectl delete crd probes.monitoring.coreos.com
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd thanosrulers.monitoring.coreos.com

## Uninstall Kiali
kubectl delete kiali kiali

helm uninstall kiali-operator
kubectl delete crd kialis.kiali.io

## Uninstall Grafana & Jaeger
kubectl delete -f maxcloud/jeager.yaml
kubectl delete -f maxcloud/jeager-proxy.yaml

kubectl delete -f maxcloud/grafana.yaml
kubectl delete -f maxcloud/grafana-proxy.yaml

kubectl delete -f maxcloud/kiali-proxy.yaml





