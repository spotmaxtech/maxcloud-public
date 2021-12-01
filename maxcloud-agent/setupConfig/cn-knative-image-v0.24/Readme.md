# 脚本用于解决国内k8s集群无法获取gcr.io镜像问题

# 1 选定一个环境完整的集群，进入knative-serving命名空间

# 2 使用脚本将image从部署的yaml中抓取下来
## 2.1 deploy image
```bash
k get deploy -o wide | awk 'NR == 1 {next} { print $1, $6, $7 }' >> kn-image.txt
```

## 2.2 job/default-domain image
```bash
k get job -o wide | awk 'NR == 1 {next} { print $1, $5, $6 }' >> kn-image.txt
```

## 2.3 configmap/config-deployment image update
```bash
echo "queue-sidecar queue-sidecar gcr.io/knative-releases/knative.dev/serving/cmd/queue@sha256:6c6fdac40d3ea53e39ddd6bb00aed8788e69e7fac99e19c98ed911dd1d2f946b" >> kn-image.txt
```

# 3 在kn.py中指定当前的knative版本 "knative_version = v0.24"

# 4 运行kn.py，会将镜像同步到我们的镜像仓库（公开）

# 5 将输出的patch信息更新到kn-image-patch.yaml中（或直接更改image的版本号即可）
其中，job和configmap需要特别的语句进行patch注意替换。