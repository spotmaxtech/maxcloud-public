#!/usr/bin/env bash
echo "install istio begin"
istioctl install -f istio-minimal.yaml -y
echo "install istio end"
