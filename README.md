# 说明
常用的公共资源，包括热门组件安装脚本

# istio install
## minimal install
```bash
git clone https://github.com/spotmaxtech/maxcloud_public.git
cd maxcloud_public/setup/istio && sh install_minimal.sh
```

# AWS 常用脚本
## 获取AWS EKS集群的admin token
```bash
bash -c "$(curl -s https://raw.githubusercontent.com/spotmaxtech/maxcloud_public/master/setup/aws/aws_token.sh)"
```
