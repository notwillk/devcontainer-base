#!/bin/sh
set -e

# Start the Docker daemon in the background if it is not already running.
# The container must be started with --privileged (or equivalent cgroup/seccomp
# permissions) for dockerd to function.
if ! pgrep -x dockerd > /dev/null 2>&1; then
    dockerd > /var/log/dockerd.log 2>&1 &
    # Wait up to 30 seconds for the daemon to become ready
    timeout 30 sh -c 'until docker info > /dev/null 2>&1; do sleep 0.5; done' \
        || { echo "Error: dockerd did not become ready within 30 seconds. Check /var/log/dockerd.log for details."; exit 1; }
fi

exec "$@"
