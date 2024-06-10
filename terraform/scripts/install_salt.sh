#!/bin/sh

curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
chmod +x ./bootstrap-salt.sh
./bootstrap-salt.sh stable
sudo sed s/"#master: salt"/"master: salt-master.utibeumanah.dev"/g /etc/salt/minion -i