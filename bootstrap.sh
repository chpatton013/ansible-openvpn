#!/usr/bin/env bash
set -euo pipefail

if [[ "$(id --user)" -ne "0" ]]; then
  echo Rerunning as root: $0 $@ >&2
  exec sudo "$0" "$@"
fi

keyserver="keyserver.ubuntu.com"
debian_signing_key_1="7638D0442B90D010"
debian_signing_key_2="8B48AD6246925553"
backports_repo="deb http://http.debian.net/debian jessie-backports main"
backports_list="/etc/apt/sources.list.d/backports.list"

# Install apt-key utilities.
apt-get update --assume-yes
apt-get install --assume-yes \
  apt-transport-https \
  ca-certificates \
  software-properties-common

# Authorize Debian signing keys.
apt-key adv --keyserver "$keyserver" --recv-keys "$debian_signing_key_1"
apt-key adv --keyserver "$keyserver" --recv-keys "$debian_signing_key_2"
# Add Debian backports repo.
echo "$backports_repo" > "$backports_list"

# Install updated ansible.
apt-get update
apt-get --target-release jessie-backports install --assume-yes "ansible"
