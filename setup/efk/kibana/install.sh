#!/bin/bash
namespace="spotmax-maxcloud"

helm install kibana -f values.yaml  elastic/kibana  -n $namespace
