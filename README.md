VDVARNISH
===================

VDVARNISH is a small shell script auto Custom & Install VARNISH CACHE for your CentOS Server.

Install VARNISH Cache from: https://varnish-cache.org/

Config based on the instructions at https://link.voduy.com/fevangelou - Thanks for Fevangelou!

----------

1/ VDVARNISH System Requirements:
-------------
Install CentOS Server: http://centos.org/

----------


2/ VDVARNISH Install:
-------------
```
yum -y update
curl -L https://github.com/duy13/VDVARNISH/raw/master/vdvarnish.sh -o vdvarnish.sh
bash vdvarnish.sh
 
```

VDVARNISH script interface:
-------------
```
        Welcome to VDVARNISH:
A shell script auto Custom & Install VARNISH for your CentOS Server.
                                                                Thanks you for using!

Which VARNISH Cache Server version you want to install [4|6]: 6
Varnish Server version => 6
Which VARNISH Cache Server Port you want to listen [82]:
Varnish Port Listen => 82
Which memory RAM size you want to use for cache (Megabytes) [512]:
Varnish Server Size Cache => 512
Which HTTP Backend Server IP address you want to reverse proxy [127.0.0.1|13.9.19.90]:
Varnish Backend IP address => 13.9.19.90
Which HTTP Backend Server Port you want to reverse proxy [8080]:
Varnish Backend Port => 8080

......................................
......................................
......................................
......................................

......................................
......................................
......................................
......................................

varnishd (varnish-6.0.0 revision a068361dff0d25a0d85cf82a6e5fdaf315e06a7d)
Copyright (c) 2006 Verdens Gang AS
Copyright (c) 2006-2015 Varnish Software AS

=====> Install and Config VDVARNISH Done! <=====
Redirecting to /bin/systemctl restart varnish.service
tcp        0      0 127.0.0.1:6082          0.0.0.0:*               LISTEN      570/varnishd
tcp        0      0 0.0.0.0:82              0.0.0.0:*               LISTEN      570/varnishd
tcp6       0      0 :::82                   :::*                    LISTEN      570/varnishd

```

3/ More Config:
---------------
Document: http://vddos.voduy.com
```
Still in beta, use at your own risk! It is provided without any warranty!
```