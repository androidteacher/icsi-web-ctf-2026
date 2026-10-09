#!/usr/bin/env bash
#
# start_env.sh — bring up the iCSI-Web-CTF environment one part at a time.
# Each Docker Compose file is started with `up -d` and the script waits for it
# to finish before starting the next, keeping Docker Hub pulls under the
# unauthenticated rate limit.
#
set -u

# Always run from the folder this script lives in.
cd "$(dirname "$0")"

# --- Pick the available compose command (v2 plugin or v1 standalone) ---
if docker compose version >/dev/null 2>&1; then
  COMPOSE="docker compose"
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE="docker-compose"
else
  echo "ERROR: neither 'docker compose' nor 'docker-compose' is installed."
  echo "Install it with: sudo apt update && sudo apt install docker.io docker-compose"
  exit 1
fi

# --- Use sudo automatically if the Docker daemon isn't reachable as this user ---
SUDO=""
if ! docker info >/dev/null 2>&1; then
  SUDO="sudo"
fi

run_part() {
  local proj="$1" file="$2"
  echo
  echo "=================================================================="
  echo " Starting ${file}  (project: ${proj})"
  echo "=================================================================="
  if ! $SUDO $COMPOSE -p "$proj" -f "$file" up -d; then
    echo
    echo "ERROR: '${file}' did not start cleanly."
    echo "If this was a Docker Hub pull rate limit ('toomanyrequests'), wait a"
    echo "few minutes or run 'docker login', then re-run ./start_env.sh."
    exit 1
  fi
}

# --- Part 1: CTFd platform (db + ctfd) + pivot challenge ---
run_part ctf1 docker-compose.part1.yml

# Wait for the CTFd platform to be reachable before launching more challenges.
if command -v curl >/dev/null 2>&1; then
  echo
  echo "Waiting for CTFd to become available on http://localhost:8000 ..."
  for i in $(seq 1 60); do
    if curl -fs -o /dev/null http://localhost:8000/ 2>/dev/null; then
      echo "CTFd is up."
      break
    fi
    sleep 3
  done
fi

# --- Parts 2 and 3: remaining challenges ---
run_part ctf2 docker-compose.part2.yml
run_part ctf3 docker-compose.part3.yml

echo
echo "=================================================================="
echo " All parts started."
echo " CTFd:  http://<THIS-HOST-IP>:8000     (admin / admin)"
echo "=================================================================="
