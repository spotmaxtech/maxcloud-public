#!/bin/bash

namespace="spotmax-maxcloud"

#配置grafana数据源  [请参照正确的prometheus svc地址]
kubectl -f grafana-datasource.yaml  -n $namespace 

#安装
kubectl -f grafana.yaml  -n $namespace 
kubectl -f grafana-proxy.yaml  -n $namespace 


