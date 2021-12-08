#!/bin/bash

namespace="spotmax-maxcloud"

##修改sa.yaml 中namespace

##部署
kubectl apply -f sa.yaml -n $namespace
kubectl apply -f configmap.yaml -n $namespace
kubectl apply -f ds.yaml -n $namespace
