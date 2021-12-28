#!/usr/bin/env bash
echo "install istio begin"
curl -s "https://raw.githubusercontent.com/spotmaxtech/maxcloud_public/master/setup/istio/istio-minimal.yaml" -o /tmp/istio-minimal.yaml
istioctl install -f /tmp/istio-minimal.yaml -y
echo "install istio end"
