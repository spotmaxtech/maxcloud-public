# patch deployment
kubectl -n knative-serving set image deployment/activator activator=registry.cn-hongkong.aliyuncs.com/spotmax/knative-activator:v0.24
kubectl -n knative-serving set image deployment/autoscaler autoscaler=registry.cn-hongkong.aliyuncs.com/spotmax/knative-autoscaler:v0.24
kubectl -n knative-serving set image deployment/autoscaler-hpa autoscaler-hpa=registry.cn-hongkong.aliyuncs.com/spotmax/knative-autoscaler-hpa:v0.24
kubectl -n knative-serving set image deployment/controller controller=registry.cn-hongkong.aliyuncs.com/spotmax/knative-controller:v0.24
kubectl -n knative-serving set image deployment/domain-mapping domain-mapping=registry.cn-hongkong.aliyuncs.com/spotmax/knative-domain-mapping:v0.24
kubectl -n knative-serving set image deployment/domainmapping-webhook domainmapping-webhook=registry.cn-hongkong.aliyuncs.com/spotmax/knative-domainmapping-webhook:v0.24
kubectl -n knative-serving set image deployment/net-istio-controller controller=registry.cn-hongkong.aliyuncs.com/spotmax/knative-net-istio-controller:v0.24
kubectl -n knative-serving set image deployment/net-istio-webhook webhook=registry.cn-hongkong.aliyuncs.com/spotmax/knative-net-istio-webhook:v0.24
kubectl -n knative-serving set image deployment/webhook webhook=registry.cn-hongkong.aliyuncs.com/spotmax/knative-webhook:v0.24

# recreate job default-domain
kubectl -n knative-serving delete job default-domain
kubectl -n knative-serving apply -f default-domain.yaml

# patch configmap/config-deployment
kubectl -n knative-serving patch configmap/config-deployment --type merge \
  -p '{"data":{"queueSidecarImage":"registry.cn-hongkong.aliyuncs.com/spotmax/knative-queue-sidecar:v0.24"}}'
