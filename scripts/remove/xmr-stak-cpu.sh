#!/bin/bash
# xmr-stak-cpu removal

user=$(cat /root/.master.info | cut -d: -f1)
systemctl disable xmr > /dev/null 2>&1
systemctl stop xmr
rm -rf /home/${user}/.xmr
rm -rf /etc/systemd/system/xmr.service
rm -rf /usr/local/bin/xmr-stak-cpu
rm -rf /install/.xmr-stak-cpu.lock
