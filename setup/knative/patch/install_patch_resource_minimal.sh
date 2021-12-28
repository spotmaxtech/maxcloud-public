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

