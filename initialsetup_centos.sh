#!/bin/bash

#CentOS initialsetup

#SSHの有効化
sudo yum -y install openssh-server
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.old
sudo sed -i -e '58i PasswordAuthentication yes ' /etc/ssh/sshd_config
sudo systemctl restart sshd

#update
sudo yum -y update

#logging Service Stop
sudo /sbin/service rsyslog stop
sudo /sbin/service auditd stop

#Yum cache clean
yum clean all

#ローテーションされた古いログ削除
sudo /usr/sbin/logrotate -f /etc/logrotate.conf && sudo /bin/rm -f /var/log/-???????? /var/log/.gz &&sudo /bin/rm -f /var/log/dmesg.old &&sudo /bin/rm -rf /var/log/anaconda


#Network構成削除
sudo /bin/rm -f /etc/udev/rules.d/70*

#SSHのホスト鍵を削除（次回起動時に自動で再生成されます）
sudo rm -f "/etc/ssh/ssh_host_*_key*"

#SSH用ディレクトリの削除（authorized_keys や　known_hosts の削除）
sudo rm -rf "/root/.ssh"
sudo find /home -maxdepth 2 -mindepth 2 -name .ssh -type d | xargs --no-run-if-empty rm -rf

#一時ファイルの削除
sudo rm -rf "/tmp/*"
sudo rm -rf "/var/tmp/*"

#yumのUUIDの削除（次回のyum使用時に自動で再生成されます）
sudo rm -f "/var/lib/yum/uuid"

#NIC設定の一部削除
sudo sed -i '/^BOOTPROTO/c\BOOTPROTO="dhcp"' /etc/sysconfig/network-scripts/ifcfg-*
#sudo find /etc/sysconfig/network-scripts -name "ifcfg-*" -not -name "ifcfg-lo" -print0 | \xargs -0 --no-run-if-empty sed -i '/^\(HWADDR\|UUID\|HOSTNAME\|DHCP_HOSTNAME\|IPADDR\|PREFIX\|NETMASK\|GATEWAY\|DNS\)/d'
sudo rm -rf "/etc/sysconfig/network-scripts/ifcfg-*.bak"

#ログ、コマンド履歴削除
sudo find /var/log/ -type f -name \* -exec cp -f /dev/null {} \;
sudo cat /dev/null > ~/.bash_history && history -c

#シャットダウン
#sudo shutdown -h now
