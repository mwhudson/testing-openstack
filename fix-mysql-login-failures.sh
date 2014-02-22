#!/bin/bash

mysql -u root <<EOF
USE mysql;
UPDATE user SET Password = PASSWORD('password')
WHERE Host = 'localhost' AND User = 'root';
FLUSH PRIVILEGES;
EOF

sudo /etc/init.d/mysql restart

