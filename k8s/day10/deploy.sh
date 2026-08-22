#!/usr/bin/env bash
set -euo pipefail
IMAGE="${1:?usage: deploy.sh IMAGE}"
CLUSTER="${2:?usage: deploy.sh IMAGE CLUSTER}"
aws eks update-kubeconfig --region ap-south-1 --name "$CLUSTER"
kubectl apply -f base.yaml
kubectl -n day10 set image deployment/app app="$IMAGE"
kubectl -n day10 rollout status deployment/app --timeout=10m
kubectl -n day10 get pods,svc,hpa,pdb
