#cloud-config
runcmd:
  - [ bash, -lc, "set -euo pipefail" ]

  - |
    RUNNER_DIR="/opt/actions-runner"

    apt-get update -y
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl jq tar

    mkdir -p $RUNNER_DIR
    cd /tmp

    # download latest linux x64 runner
    RUNNER_TGZ_URL=$(curl -s https://api.github.com/repos/actions/runner/releases/latest \
      | jq -r '.assets[] | select(.name | test("linux-x64.*tar.gz$")) | .browser_download_url')
    if [ -z "$RUNNER_TGZ_URL" ] || [ "$RUNNER_TGZ_URL" = "null" ]; then
      echo "Could not resolve runner download URL" >&2
      exit 1
    fi

    curl -sL "$RUNNER_TGZ_URL" -o /tmp/actions-runner.tar.gz
    mkdir -p $RUNNER_DIR
    tar xzf /tmp/actions-runner.tar.gz -C $RUNNER_DIR

    # create service user but do NOT configure the runner (no token yet)
    id -u githubrunner >/dev/null 2>&1 || useradd -m -s /bin/bash githubrunner
    chown -R githubrunner:githubrunner $RUNNER_DIR

    echo "Runner files downloaded and permissions set. Awaiting registration."
