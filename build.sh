##!/bin/bash 
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc
cd /root/
#Download nginx and openssl
wget https://nginx.org/packages/centos/8/SRPMS/nginx-1.24.0-1.el8.ngx.src.rpm
wget https://www.openssl.org/source/openssl-1.1.1w.tar.gz
#Install packages
rpm -i ./nginx-1.*
#Install dependencies
yum-builddep -y ./rpmbuild/SPECS/nginx.spec
#Unpak archive openssl 
tar -xvf ./openssl-1.1.1w.tar.gz
#Copy spec file
cp /vagrant/nginx.spec ./rpmbuild/SPECS/nginx.spec
#Build packages
rpmbuild -bb ./rpmbuild/SPECS/nginx.spec
#Install nginx
yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.*.rpm
#Start nginx
systemctl start nginx
#Creating folder
mkdir /usr/share/nginx/html/repo
#Copy rpm packages
cp rpmbuild/RPMS/x86_64/nginx-1.*.rpm /usr/share/nginx/html/repo/
#Download rpm packages in repo
wget https://downloads.percona.com/downloads/percona-distribution-mysql-ps/percona-distribution-mysql-ps-8.0.28/binary/redhat/8/x86_64/percona-orchestrator-3.2.6-2.el8.x86_64.rpm -O /usr/share/nginx/html/repo/percona-orchestrator-3.2.6-2.el8.x86_64.rpm
#Creating repository
createrepo /usr/share/nginx/html/repo/
#Copy config nginx
cp /vagrant/default.conf /etc/nginx/conf.d/default.conf
#Reload nginx
nginx -s reload


