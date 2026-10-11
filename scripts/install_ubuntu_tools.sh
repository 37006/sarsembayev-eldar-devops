#!/usr/bin/env bash
# Official Ubuntu, Docker and Jenkins repositories; no automated OS upgrade.
set -euo pipefail
if [[ "${EUID}" -ne 0 ]]; then
  echo 'Run as root: sudo bash scripts/install_ubuntu_tools.sh' >&2
  exit 1
fi
source /etc/os-release
if [[ "$ID" != ubuntu || "$VERSION_ID" != 24.04 ]]; then
  echo 'This installer is prepared for Ubuntu 24.04. Review other releases separately.' >&2
  exit 1
fi
if [[ "$(cat /proc/1/comm)" != systemd ]]; then
  echo 'systemd is required for Docker and Jenkins services.' >&2
  echo 'Enable [boot] systemd=true in /etc/wsl.conf, restart this WSL distribution, then retry.' >&2
  exit 1
fi
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y ca-certificates curl gnupg git python3 python3-venv unzip \
  procps fontconfig openjdk-21-jre

if ! command -v docker >/dev/null 2>&1; then
  for conflicting in docker.io docker-compose docker-compose-v2 podman-docker containerd runc; do
    if dpkg-query -W -f='${Status}' "$conflicting" 2>/dev/null | grep -q 'install ok installed'; then
      echo "Existing package requires review before installing Docker CE: $conflicting" >&2
      exit 1
    fi
  done
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  cat > /etc/apt/sources.list.d/docker.sources <<SOURCES
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${UBUNTU_CODENAME:-$VERSION_CODENAME}
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
SOURCES
  apt-get update
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

if ! dpkg-query -W -f='${Status}' jenkins 2>/dev/null | grep -q 'install ok installed'; then
  # Configure the local-only binding before package installation can start Jenkins.
  mkdir -p /etc/systemd/system/jenkins.service.d
  cat > /etc/systemd/system/jenkins.service.d/local-lab.conf <<'SERVICE'
[Service]
Environment="JENKINS_OPTS=--httpListenAddress=127.0.0.1"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.net.preferIPv4Stack=true"
SERVICE
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
    -o /etc/apt/keyrings/jenkins-keyring.asc
  printf '%s\n' 'deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/' \
    > /etc/apt/sources.list.d/jenkins.list
  apt-get update
  apt-get install -y jenkins
fi

usermod -aG docker jenkins
if [[ -n "${SUDO_USER:-}" && "$SUDO_USER" != root ]]; then
  usermod -aG docker "$SUDO_USER"
fi
systemctl daemon-reload
systemctl enable --now docker
systemctl restart jenkins
systemctl enable jenkins
docker info --format 'Docker server: {{.ServerVersion}}'
docker compose version
python3 --version
java -version
systemctl is-active docker jenkins
echo 'Open http://localhost:8080/ for the Jenkins first-run setup.'
echo 'The initial admin password remains in the protected Jenkins file; it is not printed here.'
echo 'A new user session may be required for the docker group membership.'
