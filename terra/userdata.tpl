#cloud-config
runcmd:
  - [ bash, -lc, "set -euo pipefail" ]

  - |
    REG_TOKEN="${registration_token}"
    GITHUB_ORG="${github_org}"
    RUNNER_LABELS="${runner_labels}"
    RUNNER_DIR="/opt/actions-runner"
    RUNNER_SERVICE="/etc/systemd/system/github-runner.service"

    if [ -z "${REG_TOKEN}" ] || [ "${REG_TOKEN}" = "null" ]; then
      echo "No registration token provided; exiting" >&2
      exit 1
    fi

    apt-get update -y
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl jq tar

    mkdir -p ${RUNNER_DIR}
    cd /tmp

    # get latest linux x64 runner
    RUNNER_TGZ_URL=$(curl -s https://api.github.com/repos/actions/runner/releases/latest \
      | jq -r '.assets[] | select(.name | test("linux-x64.*tar.gz$")) | .browser_download_url')
    if [ -z "${RUNNER_TGZ_URL}" ] || [ "${RUNNER_TGZ_URL}" = "null" ]; then
      echo "Could not resolve runner download URL" >&2
      exit 1
    fi

    curl -sL "${RUNNER_TGZ_URL}" -o /tmp/actions-runner.tar.gz
    tar xzf /tmp/actions-runner.tar.gz -C ${RUNNER_DIR}

    # create service user
    id -u githubrunner >/dev/null 2>&1 || useradd -m -s /bin/bash githubrunner
    chown -R githubrunner:githubrunner ${RUNNER_DIR}

    RUNNER_NAME="runner-$(hostname)-$(date +%s)"
    cd ${RUNNER_DIR}
    sudo -u githubrunner bash -lc "./config.sh --unattended --url https://github.com/${GITHUB_ORG} --token ${REG_TOKEN} --name ${RUNNER_NAME} --labels ${RUNNER_LABELS} --work _work --replace || true"

    # systemd unit
    cat > ${RUNNER_SERVICE} <<'EOF'
[Unit]
Description=GitHub Actions Runner
After=network.target

[Service]
Type=simple
User=githubrunner
WorkingDirectory=/opt/actions-runner
ExecStart=/opt/actions-runner/run.sh
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable --now github-runner.service || true

    # best-effort cleanup
    unset REG_TOKEN
    history -c || true

    echo "runner registration completed"
