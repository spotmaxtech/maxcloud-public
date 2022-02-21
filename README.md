# 说明
常用的公共资源，包括热门组件安装脚本

# istio install
## minimal install
这个脚本安装的istio占用cpu/mem资源最小
```bash
bash -c "$(curl -s https://raw.githubusercontent.com/spotmaxtech/maxcloud_public/master/setup/istio/install_minimal.sh)"
```

## default install
```bash
bash -c "$(curl -s https://raw.githubusercontent.com/spotmaxtech/maxcloud_public/master/setup/istio/install_default.sh)"
```

# knative install
```bash
bash -c "$(curl -s https://raw.githubusercontent.com/spotmaxtech/maxcloud_public/master/setup/knative/install.sh)"
```

## minimal patch
这个脚本可以降低占用cpu/mem资源
```bash
bash -c "$(curl -s https://raw.githubusercontent.com/spotmaxtech/maxcloud_public/master/setup/knative/patch/install_patch_resource_minimal.sh)"
```

# grafana install
```bash
bash -c "$(curl -s https://raw.githubusercontent.com/spotmaxtech/maxcloud_public/master/setup/grafana/install.sh)"
```

# AWS 常用脚本
## 获取AWS EKS集群的admin token
```bash
bash -c "$(curl -s https://raw.githubusercontent.com/spotmaxtech/maxcloud_public/master/setup/aws/aws_token.sh)"
```
