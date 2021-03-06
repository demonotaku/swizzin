#!/bin/bash
#
# Swizzin :: Shellinabox installer
# Author: liara
#
# Copyright (C) 2017 Swizzin
# Licensed under GNU General Public License v3.0 GPL-3
#################################################################################

apt-get -y -q update > /dev/null 2>&1
apt-get -y install shellinabox > /dev/null 2>&1

service shellinabox stop > /dev/null 2>&1
rm -rf /etc/init.d/shellinabox

cat > /etc/systemd/system/shellinabox.service <<SIAB
[Unit]
Description=Shell in a Box service
Required=sshd.service
After=sshd.service

[Service]
User=root
Type=forking
EnvironmentFile=/etc/default/shellinabox
ExecStart=/usr/bin/shellinaboxd -q --background=/var/run/shellinaboxd.pid -c /var/lib/shellinabox -p 4200 -u shellinabox -g shellinabox \$SHELLINABOX_ARGS
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-abort

[Install]
WantedBy=multi-user.target
SIAB

if [[ -f /install/.nginx.lock ]]; then
    bash /usr/local/bin/swizzin/nginx/shellinabox.sh
fi

systemctl daemon-reload
systemctl enable shellinabox > /dev/null 2>&1
systemctl start shellinabox

touch /install/.shellinabox.lock