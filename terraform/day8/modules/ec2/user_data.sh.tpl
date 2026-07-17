#!/bin/bash

set -Eeuo pipefail

exec > >(tee /var/log/day8-user-data.log | logger -t day8-user-data -s 2>/dev/console) 2>&1

readonly DOCKER_IMAGE="${docker_image}"
readonly CONTAINER_NAME="${container_name}"
readonly APPLICATION_PORT="${application_port}"
readonly HOST_PORT="${host_port}"

retry() {
  local retries="$1"
  shift

  local count=0

  until "$@"; do
    exit_code=$?
    count=$((count + 1))

    if [ "$count" -ge "$retries" ]; then
      echo "Command failed after $count attempts: $*"
      return "$exit_code"
    fi

    sleep $((count * 5))
  done
}

dnf update -y
dnf install -y docker

systemctl enable --now docker

usermod -aG docker ec2-user || true

mkdir -p /opt/day8

cat > /etc/systemd/system/day8-app.service <<UNIT
[Unit]
Description=Day 8 Docker Application
Requires=docker.service
After=docker.service network-online.target
Wants=network-online.target

[Service]
Type=simple
Restart=always
RestartSec=10
TimeoutStartSec=180
TimeoutStopSec=30

ExecStartPre=-/usr/bin/docker rm -f \${CONTAINER_NAME}
ExecStartPre=/usr/bin/docker pull \${DOCKER_IMAGE}

ExecStart=/usr/bin/docker run \
  --name \${CONTAINER_NAME} \
  --read-only \
  --tmpfs /tmp:size=16m,mode=1777 \
  --security-opt no-new-privileges:true \
  --cap-drop ALL \
  --pids-limit 100 \
  --memory 256m \
  --cpus 0.50 \
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  -e NODE_ENV=production \
  -e APP_VERSION=\${DOCKER_IMAGE} \
  -p \${HOST_PORT}:\${APPLICATION_PORT} \
  \${DOCKER_IMAGE}

ExecStop=/usr/bin/docker stop --time 20 \${CONTAINER_NAME}
ExecStopPost=-/usr/bin/docker rm -f \${CONTAINER_NAME}

[Install]
WantedBy=multi-user.target
UNIT

systemctl daemon-reload
systemctl enable day8-app.service

retry 5 docker pull "$DOCKER_IMAGE"

systemctl start day8-app.service

retry 12 curl \
  --fail \
  --silent \
  --show-error \
  "http://127.0.0.1:$HOST_PORT/health/ready"

echo "Day 8 deployment completed successfully."