#!/bin/bash

sudo service mysql stop
sudo /usr/sbin/mysqld --skip-grant-tables --skip-networking &

sleep 15

mysql -u root <<EOF
USE mysql;
UPDATE user SET Password = PASSWORD('password')
WHERE Host = 'localhost' AND User = 'root';
FLUSH PRIVILEGES;
EOF

sudo pkill mysqld
sudo service mysql start

