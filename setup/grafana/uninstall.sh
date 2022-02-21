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

grafana_dir=$public_dir/setup/grafana_dir

kubectl delete -f $grafana_dir/grafana-datasource.yaml
kubectl delete -f $grafana_dir/grafana.yaml
kubectl delete -f $grafana_dir/grafana-proxy.yaml


