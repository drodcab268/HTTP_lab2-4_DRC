#!/bin/bash

set -e

apt-get update
apt-get install -y openssl

a2enmod ssl

grep -q "Listen 443" /etc/apache2/ports.conf || echo "Listen 443" >> /etc/apache2/ports.conf

mkdir -p /etc/apache2/ssl

openssl req -x509 -nodes -days 365 \
-newkey rsa:2048 \
-keyout /etc/apache2/ssl/discovery.key \
-out /etc/apache2/ssl/discovery.crt \
-subj "/C=ES/ST=Granada/L=Granada/O=IES/OU=ASIR/CN=discovery.sistema.sol"


cat <<EOF > /etc/apache2/sites-available/discovery.sistema.sol-ssl.conf
<VirtualHost *:443>
    ServerName discovery.sistema.sol
    DocumentRoot /var/www/discovery.sistema.sol

    SSLEngine on
    SSLCertificateFile /etc/apache2/ssl/discovery.crt
    SSLCertificateKeyFile /etc/apache2/ssl/discovery.key

    <Directory /var/www/discovery.sistema.sol>
        Require all granted
    </Directory>
</VirtualHost>
EOF

a2ensite discovery.sistema.sol-ssl.conf

systemctl restart apache2
systemctl status apache2
