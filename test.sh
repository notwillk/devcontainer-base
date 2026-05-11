#!/usr/bin/env bash
set -euo pipefail

pass() { echo "PASS: $1"; }
fail() { echo "FAIL: $1"; exit 1; }

echo "=== Running devcontainer tests ==="

# docker CLI is present
which docker > /dev/null 2>&1 && pass "docker binary found" || fail "docker binary not found"

# docker reports a version
docker --version > /dev/null 2>&1 && pass "docker --version works" || fail "docker --version failed"

# docker compose plugin is present
docker compose version > /dev/null 2>&1 && pass "docker compose plugin found" || fail "docker compose plugin not found"

# docker buildx plugin is present
docker buildx version > /dev/null 2>&1 && pass "docker buildx plugin found" || fail "docker buildx plugin not found"

# docker daemon is reachable
docker info > /dev/null 2>&1 && pass "docker daemon reachable" || fail "docker daemon not reachable"

# ansible is present
which ansible > /dev/null 2>&1 && pass "ansible binary found" || fail "ansible binary not found"

# ansible reports a version
ansible --version > /dev/null 2>&1 && pass "ansible --version works" || fail "ansible --version failed"

echo "=== All tests passed ==="
