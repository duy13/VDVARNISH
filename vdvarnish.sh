#!/bin/bash
PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/bin



if [ $(id -u) != "0" ]; then
echo 'ERROR! Please su root and try again!
'
exit 0
fi
os=$(cut -f 1 -d ' ' /etc/redhat-release)
release=$(grep -o "[0-9]" /etc/redhat-release |head -n1)
arch=`arch`
IP=`curl -s -L http://cpanel.net/showip.cgi`
random=`cat /dev/urandom | tr -cd 'A-Z0-9' | head -c 5`
if [ ! -f /etc/redhat-release ] || [ "$os" != "CentOS" ]; then
echo 'ERROR! Please use CentOS Linux release 7 x86_64!
'
exit 0
fi

if [ -f /etc/varnish/default.vcl  ]; then
echo 'ERROR! Varnish service is already installed!'
exit 0
fi



should_ask="$1"

if [ "$should_ask" = "" ]; then should_ask="y"; fi
if [ "$should_ask" = "noask" ]; then should_ask="n"; fi



Varnish_Server_version=4; Varnish_Server_port=82; Varnish_Server_sizecache=512; 
Varnish_Backend_ip="$IP"; Varnish_Backend_port=8080;


if [ "$should_ask" = "y" ]; then 
clear
echo '	Welcome to VDVARNISH:
A shell script auto Custom & Install VARNISH for your CentOS Server.
								Thanks you for using!
'


echo -n 'Which VARNISH Cache Server version you want to install [4|6]: '
read Varnish_Server_version
if [ "$Varnish_Server_version" != "4" ] && [ "$Varnish_Server_version" != "6" ]; then
Varnish_Server_version=4
fi
echo 'Varnish Server version => '$Varnish_Server_version''


echo -n 'Which VARNISH Cache Server Port you want to listen [82]: '
read Varnish_Server_port
if [ "$Varnish_Server_port" = "" ]; then
Varnish_Server_port=82
fi
if [ "$Varnish_Server_port" -le "65535" ];
then
echo 'Varnish Port Listen => '$Varnish_Server_port''
else
Varnish_Server_port=82
echo 'Varnish Port Listen => '$Varnish_Server_port''
fi

echo -n 'Which memory RAM size you want to use for cache (Megabytes) [512]: '
read Varnish_Server_sizecache
if [ "$Varnish_Server_sizecache" = "" ]; then
Varnish_Server_sizecache=512
fi
echo 'Varnish Server Size Cache => '$Varnish_Server_sizecache''


echo -n 'Which HTTP Backend Server IP address you want to reverse proxy [127.0.0.1|'$IP']: '
read Varnish_Backend_ip
if [ "$Varnish_Backend_ip" = "" ]; then
Varnish_Backend_ip="$IP"
fi
echo 'Varnish Backend IP address => '$Varnish_Backend_ip''

echo -n 'Which HTTP Backend Server Port you want to reverse proxy [8080]: '
read Varnish_Backend_port
if [ "$Varnish_Backend_port" = "" ]; then
Varnish_Backend_port=8080
fi
echo 'Varnish Backend Port => '$Varnish_Backend_port''

fi

yum -y install epel-release
yum -y install pygpgme yum-utils

if [ "$Varnish_Server_version" = "4" ]; then
echo '[varnishcache_varnish41]
name=varnishcache_varnish41
baseurl=https://packagecloud.io/varnishcache/varnish41/el/'$release'/$basearch
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/varnishcache/varnish41/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[varnishcache_varnish41-source]
name=varnishcache_varnish41-source
baseurl=https://packagecloud.io/varnishcache/varnish41/el/'$release'/SRPMS
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/varnishcache/varnish41/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300' > /etc/yum.repos.d/varnishcache_varnish41.repo

yum -q makecache -y --disablerepo='*' --enablerepo='varnishcache_varnish41'
fi


if [ "$Varnish_Server_version" = "6" ]; then
echo '[varnishcache_varnish60lts]
name=varnishcache_varnish60lts
baseurl=https://packagecloud.io/varnishcache/varnish60lts/el/'$release'/$basearch
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/varnishcache/varnish60lts/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300

[varnishcache_varnish60lts-source]
name=varnishcache_varnish60lts-source
baseurl=https://packagecloud.io/varnishcache/varnish60lts/el/'$release'/SRPMS
repo_gpgcheck=1
gpgcheck=0
enabled=1
gpgkey=https://packagecloud.io/varnishcache/varnish60lts/gpgkey
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300' > /etc/yum.repos.d/varnishcache_varnish60lts.repo

yum -q makecache -y --disablerepo='*' --enablerepo='varnishcache_varnish60lts'


fi

yum -y install varnish

if [ ! -f /usr/sbin/varnishd  ]; then
echo 'ERROR! Varnish Server installation failed!'
exit 0
fi


mv /etc/varnish/varnish.params /etc/varnish/varnish.params.bak.$random
mv /etc/varnish/default.vcl /etc/varnish/default.vcl.bak.$random

curl -L https://github.com/duy13/vdvarnish/raw/master/default.vcl.txt -o /etc/varnish/default.vcl
curl -L https://github.com/duy13/vdvarnish/raw/master/varnish.params.txt -o /etc/varnish/varnish.params

goc=`curl -L https://raw.githubusercontent.com/duy13/vdvarnish/master/md5sum.txt --silent | grep "default.vcl.txt" |awk 'NR==1 {print $1}'`
tai=`md5sum /etc/varnish/default.vcl | awk 'NR==1 {print $1}'`
if [ "$goc" != "$tai" ]; then
	rm -rf /etc/varnish/default.vcl
	curl -L https://files.voduy.com/VDVARNISH/default.vcl.txt -o /etc/varnish/default.vcl
fi

goc=`curl -L https://raw.githubusercontent.com/duy13/vdvarnish/master/md5sum.txt --silent | grep "varnish.params.txt" |awk 'NR==1 {print $1}'`
tai=`md5sum /etc/varnish/varnish.params | awk 'NR==1 {print $1}'`
if [ "$goc" != "$tai" ]; then
	rm -rf /etc/varnish/varnish.params
	curl -L https://files.voduy.com/VDVARNISH/varnish.params.txt -o /etc/varnish/varnish.params
fi

if [ "$should_ask" = "y" ]; then 
sed -i "s#82#$Varnish_Server_port#g" /etc/varnish/varnish.params
sed -i "s#512#$Varnish_Server_sizecache#g" /etc/varnish/varnish.params

sed -i "s#127.0.0.1#$Varnish_Backend_ip#g" /etc/varnish/default.vcl
sed -i "s#8080#$Varnish_Backend_port#g" /etc/varnish/default.vcl
fi

if [ "$Varnish_Server_version" = "6" ]; then
sed -i "s#6081#$Varnish_Server_port#g" /usr/lib/systemd/system/varnish.service
sed -i "s#256#$Varnish_Server_sizecache#g" /usr/lib/systemd/system/varnish.service
fi

chkconfig varnish on
service varnish restart >/dev/null 2>&1 ; sleep 5; 

varnishd -V
echo '
=====> Install and Config VDVARNISH Done! <====='
netstat -lntup|grep varnishd

