# create dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

# create admin binding
k apply -f setup/kubernetes-dashboard/cluster-admin-role-binding.yaml 

# get secret token
