#!/bin/bash

wget --no-check-certificate -O gost.sh https://cdn.jsdelivr.net/gh/KANIKIG/Multi-EasyGost@master/gost.sh && chmod +x gost.sh && echo -e 1 | ./gost.sh

cat > /etc/rc.local <<EOF
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.
# bash /root/bindip.sh
exit 0
EOF

chmod +x /etc/rc.local

cat > /etc/systemd/system/rc-local.service <<EOF
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
EOF

systemctl enable rc-local

systemctl start rc-local.service

sed -i '/exit 0/i\nohup gost -L socks5://user:pass@:1088 > /root/socks.log 2>&1 &' /etc/rc.local && systemctl enable rc-local && systemctl start rc-local.service

reboot