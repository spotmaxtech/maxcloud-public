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

knative_dir=$public_dir/setup/knative

kubectl patch deployment activator --patch-file $knative_dir/patch/deployment-activator.yaml -n knative-serving
kubectl patch deployment activator --patch-file $knative_dir/patch/deployment-autoscaler.yaml -n knative-serving
kubectl patch deployment activator --patch-file $knative_dir/patch/deployment-autoscaler-hpa.yaml -n knative-serving
