#!/bin/bash
namespace="spotmax-maxcloud"

helm install kibana -f values.yaml  elastic/kibana  -n $namespace

kubectl install -f kibana-proxy.yaml -n $namespace