FROM    centos:centos6
MAINTAINER      oshige456
RUN     yum update -y
RUN     yum install mysql mysql-server -y
RUN     yum install http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm -y
RUN     yum install zabbix-server-mysql -y

RUN     /usr/bin/mysql_install_db --datadir=/var/lib/mysql --user=mysql
RUN     chown -R mysql:mysql /var/lib/mysql

ADD     ./sql/schema.sql /tmp/schema.sql
ADD     ./sql/data.sql /tmp/data.sql
ADD     ./sql/images.sql /tmp/images.sql

RUN     /usr/bin/mysqld_safe & sleep 10s; mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin;"
RUN     /usr/bin/mysqld_safe & sleep 10s; mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix'; flush privileges;"

RUN     /usr/bin/mysqld_safe & sleep 10s; mysql -uroot zabbix < /tmp/schema.sql
RUN     /usr/bin/mysqld_safe & sleep 10s; mysql -uroot zabbix < /tmp/images.sql
RUN     /usr/bin/mysqld_safe & sleep 10s; mysql -uroot zabbix < /tmp/data.sql

EXPOSE  3306
CMD     ["/usr/bin/mysqld_safe"]
