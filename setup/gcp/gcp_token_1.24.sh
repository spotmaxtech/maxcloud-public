#!/bin/bash

configPath="`pwd`/config"
configFile="${configPath}/config"

export KUBECONFIG="${configFile}"

which gcloud >> /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "ERROR: gcloud command not found"
    exit 1
fi

which kubectl >> /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "ERROR: kubectl command not found"
    exit 1
fi

getRegion() {
    read -p "请输入集群所在区域：" region
    if [ -z "$region" ]; then
      getRegion
    fi
}

getName() {
    read -p "请输入集群名称：" name
    if [ -z "$name" ]; then
      getName
    fi
}

confirm() {
    echo
    echo 集群所在区域：【"$region"】
    echo 集群名称： 【"$name"】

    echo ''
    read -r -p "请确认输入信息是否正确? [Y/n] " input

    case $input in
        [yY][eE][sS]|[yY])
            echo "continue"
            ;;
        [nN][oO]|[nN])
            getCluster
            ;;
        *)
            echo "Invalid input..."
            confirm
            ;;
    esac
}

getCluster() {
    getRegion
    getName

    confirm
}

getCluster

echo '配置文件保存到下面目录中'
echo $configFile

############### create k8s config begin
# init k8s config
echo 'init k8s config'
mkdir -p $configPath
touch $configFile
gcloud container clusters get-credentials $name --region $region
if [ $? -ne 0 ]; then
    echo 'create gcloud kubeconfig file error,please check network'
    echo 'retry later ...'
    exit 1
fi


# create k8s Account
echo 'create k8s Account'
#kubectl apply -f k8s/ServiceAccount.yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: spotmax-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: spotmax-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: spotmax-admin
  namespace: kube-system
EOF

kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: spotmax-admin-token
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: spotmax-admin
type: kubernetes.io/service-account-token
EOF

echo 'create k8s Account success'

echo 'get k8s token'

token=`kubectl -n kube-system get secret spotmax-admin-token -o jsonpath='{.data.token}'|base64 -d`

row=`grep -n "exec" $configFile | head -1 | cut -d ":" -f 1`

sed -i '' '1',"`expr $row - 1`"'!d' config/config
if [ $? -ne 0 ]; then
  sed -i '1',"`expr $row - 1`"'!d' config/config
fi

echo "    token: $token" >> $configFile

echo 'get k8s token success'
############### create k8s config end


echo ''
echo ''
echo "########################################################"
echo ''
echo "生成 config 成功, 复制后面内容 到MaxCloud 平台添加集群"
echo ''
echo "########################################################"
echo ''
echo ''

cat $configFile

echo ''
echo ''

