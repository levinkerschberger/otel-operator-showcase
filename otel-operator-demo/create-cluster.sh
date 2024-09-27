eksctl create cluster -f cluster-config.yaml
export CLUSTER_REGION=eu-west-1
export CLUSTER_VPC=$(aws eks describe-cluster --name otel-summit --region $CLUSTER_REGION --query "cluster.resourcesVpcConfig.vpcId" --output text)
export REPOSITORY_PREFIX=nteduardschander
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
    --namespace kube-system \
    --set clusterName=web-quickstart \
    --set serviceAccount.create=false \
    --set region=${CLUSTER_REGION} \
    --set vpcId=${CLUSTER_VPC} \
    --set serviceAccount.name=aws-load-balancer-controller

kubectl create namespace spring-petclinic --save-config
kubectl apply -f ./spring-petclinic-cloud/k8s/init-namespace/ 
kubectl apply -f ./spring-petclinic-cloud/k8s/init-services

kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install vets-db-mysql bitnami/mysql --namespace spring-petclinic --version 11.1.16 --set auth.database=service_instance_db
helm install visits-db-mysql bitnami/mysql --namespace spring-petclinic  --version 11.1.16 --set auth.database=service_instance_db
helm install customers-db-mysql bitnami/mysql --namespace spring-petclinic  --version 11.1.16 --set auth.database=service_instance_db

./scripts/deployToKubernetes.sh
^