#! /bin/bash
#centos7.4 postfix安装脚本


#时间时区同步，修改主机名
ntpdate cn.pool.ntp.org
hwclock --systohc
echo "*/30 * * * * root ntpdate -s 3.cn.poop.ntp.org" >> /etc/crontab

sed -i 's|SELINUX=.*|SELINUX=disabled|' /etc/selinux/config
sed -i 's|SELINUXTYPE=.*|#SELINUXTYPE=targeted|' /etc/selinux/config
sed -i 's|SELINUX=.*|SELINUX=disabled|' /etc/sysconfig/selinux 
sed -i 's|SELINUXTYPE=.*|#SELINUXTYPE=targeted|' /etc/sysconfig/selinux
setenforce 0 && systemctl stop firewalld && systemctl disable firewalld 

rm -rf /var/run/yum.pid 
rm -rf /var/run/yum.pid

#配置Postfix(发送)服务程序
mailhostname=mail.zoujing.com
maildomain=zoujing.com
echo "$mailhostname" >> /etc/hostname && hostname $mailhostname
yum -y install postfix

sed -i "s|#myhostname = virtual.domain.tld|myhostname = $mailhostname|" /etc/postfix/main.cf
sed -i "s|#mydomain = domain.tld|mydomain = $maildomain|" /etc/postfix/main.cf
sed -i 's|#myorigin = $mydomain|myorigin = $mydomain|' /etc/postfix/main.cf
sed -i 's|inet_interfaces = localhost|inet_interfaces = all|' /etc/postfix/main.cf
sed -i 's|mydestination = $myhostname, localhost.$mydomain, localhost| mydestination = $myhostname, $mydomain|' /etc/postfix/main.cf

useradd boss
echo "linuxprobe" | passwd --stdin boss
systemctl restart postfix
systemctl enable postfix

#配置Dovecot(接收)服务程序
#yum -y install dovecot
#sed -i 's|#protocols = imap pop3 lmtp|protocols = imap pop3 lmtp|' /etc/dovecot/dovecot.conf
#sed -i '/protocols = imap pop3 lmtp/i\disable_plaintext_auth = no' /etc/dovecot/dovecot.conf
#sed -i 's|#   mail_location = mbox:~/mail:INBOX=/var/mail/%u|mail_location = mbox:~/mail:INBOX=/var/mail/%u|' /etc/dovecot/conf.d/10-mail.conf 
#su - boss -c 'mkdir -p mail/.imap/INBOX'
#systemctl restart dovecot 