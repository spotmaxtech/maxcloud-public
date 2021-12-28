# 说明
常用的公共资源，包括热门组件安装脚本

# istio install
## minimal install
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
```bash
bash -c "$(curl -s https://raw.githubusercontent.com/spotmaxtech/maxcloud_public/master/setup/knative/patch/install_patch_resource_minimal.sh)"
```


# AWS 常用脚本
## 获取AWS EKS集群的admin token
```bash
bash -c "$(curl -s https://raw.githubusercontent.com/spotmaxtech/maxcloud_public/master/setup/aws/aws_token.sh)"
```
