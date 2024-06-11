#!/bin/sh

curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
chmod +x ./bootstrap-salt.sh
sudo ./bootstrap-salt.sh -M -N stable
sudo systemctl start salt-master
