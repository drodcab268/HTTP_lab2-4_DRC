#!/bin/bash

set -e

apt-get update
apt-get install -y apache2 apache2-utils

cp -v /vagrant/config/tierra/apache2.conf /etc/apache2/

cp -v /vagrant/config/tierra/discovery.sistema.sol.conf \
      /etc/apache2/sites-available/

mkdir -p /var/www/discovery.sistema.sol/{basic/{ventas,desarrollo},digest}

echo "<h1>Discovery</h1>" > /var/www/discovery.sistema.sol/index.html
echo "<h1>Basic</h1>" > /var/www/discovery.sistema.sol/basic/index.html
echo "<h1>Ventas</h1>" > /var/www/discovery.sistema.sol/basic/ventas/index.html
echo "<h1>Desarrollo</h1>" > /var/www/discovery.sistema.sol/basic/desarrollo/index.html
echo "<h1>Digest OK</h1>" > /var/www/discovery.sistema.sol/digest/hello.html

chown -R www-data:www-data /var/www/discovery.sistema.sol

htpasswd -b -c /etc/apache2/.htpasswd_basic arturo arturo
htpasswd -b /etc/apache2/.htpasswd_basic ana ana
htpasswd -b /etc/apache2/.htpasswd_basic maria maria

cat <<EOF > /etc/apache2/.htgroups
ventas: arturo
desarrollo: ana
EOF

htdigest -c /etc/apache2/.htpasswd_digest astronauts commander <<EOF
commander
commander
EOF

a2dissite 000-default.conf
a2ensite discovery.sistema.sol.conf

a2enmod auth_basic
a2enmod auth_digest

systemctl restart apache2
systemctl status apache2
