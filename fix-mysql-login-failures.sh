#!/bin/bash

sudo service mysql stop
sudo /usr/sbin/mysqld --skip-grant-tables --skip-networking &

mysql -u root <<EOF
USE mysql;
UPDATE user SET Password = PASSWORD('password')
WHERE Host = 'localhost' AND User = 'root';
FLUSH PRIVILEGES;
EOF

sudo service mysql restart

