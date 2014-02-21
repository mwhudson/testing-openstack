#!/bin/bash

mysqldbin=`which mysqld`

sudo service mysql stop
sudo ${mysqldbin} --skip-grant-tables --skip-networking &

mysql -u root <<EOF
USE mysql;
UPDATE user SET Password = PASSWORD('password')
WHERE Host = 'localhost' AND User = 'root';
FLUSH PRIVILEGES;
EOF

sudo pkill mysqld
sudo service mysql start

