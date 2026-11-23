#!/bin/sh
# Runs as the Renovate image user. The image PATH starts with /home/ubuntu/bin
# (containerbase), including after /usr/local/etc/env is sourced.
# The workflow mounts a pinned static aqua binary at /opt/aqua/aqua.
set -eu

if [ ! -x /opt/aqua/aqua ]; then
  echo "aqua is not mounted at /opt/aqua/aqua" >&2
  exit 1
fi

mkdir -p /home/ubuntu/bin
cp /opt/aqua/aqua /home/ubuntu/bin/aqua
chmod 755 /home/ubuntu/bin/aqua

export PATH="/home/ubuntu/bin:${PATH}"
aqua version
exec renovate
