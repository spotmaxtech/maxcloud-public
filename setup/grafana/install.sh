#!/bin/bash

namespace="spotmax-maxcloud"

#配置grafana数据源  [请参照正确的prometheus svc地址]
kubectl apply -f grafana-datasource.yaml  -n $namespace

#安装
kubectl apply -f grafana.yaml  -n $namespace
kubectl apply -f grafana-proxy.yaml  -n $namespace


