#!/bin/bash
set -xe

apt update -y
apt install -y docker.io

systemctl enable docker
systemctl start docker

docker rm -f day7-app || true
docker pull ${docker_image}

docker run -d \
  --name day7-app \
  --restart unless-stopped \
  -p 80:8080 \
  ${docker_image}