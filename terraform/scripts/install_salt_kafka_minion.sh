#!/bin/sh

curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
chmod +x ./bootstrap-salt.sh
sudo ./bootstrap-salt.sh stable
sudo sed s/"#master: salt"/"master: salt-master.utibeumanah.dev"/g /etc/salt/minion -i
random=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)
sudo sed s/"#id:"/"id: kafka-${random}"/g /etc/salt/minion -i
sudo systemctl restart salt-minion
