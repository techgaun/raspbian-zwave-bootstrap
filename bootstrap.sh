#!/bin/bash

# Author: techgaun
# Date: 03/30/2017
# This script is responsible for performing clean install of openzwave and python-openzwave on Raspbian.
# This script also should work fine on standard debian based distros such as Ubuntu.
# This script will install environment for non-root users.
# The files will be in /opt/techgaun directory and a new user techgaun will have a virtualenv with python3

red='\033[0;31m'
green='\033[0;32m'
nc='\033[0m'
default_err="An error occurred."
root_dir="${ROOT_DIR:-/opt/techgaun}"
pyozw_dir="${root_dir}/pyozw"
pyozw_branch="python3"
pyozw_url="https://github.com/OpenZWave/python-openzwave.git"
user="${ZWAVE_USER:-techgaun}"
zwave_log_file="/var/log/techgaun-zwave.log"

is_root() {
    [[ "$(id -u)" == "0" ]]
}

is_debian() {
    [[ -f "/usr/bin/apt-get" ]]
}

error() {
    msg="${1:-$default_err}"
    echo -e "${red}${msg}${nc}"
}

msg() {
    msg="${1:-nothing}"
    echo -e "${green}${msg}${nc}"
}

fatal() {
    error "${1}"
    exit 1
}

is_root || fatal "this script must be run as a root user"
is_debian || fatal "this script only works on debian based systems eg. raspbian"

apt install -y python3-pip python3-dev libudev-dev python3-sphinx python3-setuptools git
pip3 install --upgrade virtualenv
adduser --system "${user}"
addgroup "${user}"
usermod -G dialout -a "${user}"
mkdir "${root_dir}"
chown -R "${user}:${user}" "${root_dir}"

sudo -u "${user}" bash << EOF
cd "${root_dir}"
virtualenv -p python3 "${root_dir}"
source "${root_dir}/bin/activate"
pip install Cython==0.24.1
pip install setuptools
rm -rf "${pyozw_dir}"
rm -rf "${pyozw_tar}"

git clone -b "${pyozw_branch}" "${pyozw_url}" "${pyozw_dir}"

cd "${pyozw_dir}"
make clean
make update
make build
make install-api
EOF

touch "${zwave_log_file}"
chown -R "${user}:${user}" "${zwave_log_file}"

msg "Finished installing the environment at ${root_dir}"
