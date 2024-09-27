kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.yaml
kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml

kubectl apply -f opentelemetry/collector-daemonset.yaml
kubectl apply -f opentelemetry/collector-sidecar.yaml
kubectl apply -f opentelemetry/instrumentation.yaml
