#!/bin/bash
set -e

echo "==> Instalando Apache"
apt-get update
apt-get install -y apache2 apache2-utils

echo "==> Copiando configuración base"
cp -v /vagrant/config/tierra/apache2.conf /etc/apache2/

echo "==> Copiando VirtualHost"
cp -v /vagrant/config/tierra/discovery.sistema.sol.conf \
      /etc/apache2/sites-available/

echo "==> Copiando contenido web"
cp -rv /vagrant/config/tierra/web/discovery.sistema.sol \
       /var/www/

chown -R www-data:www-data /var/www/discovery.sistema.sol

echo "==> Copiando ficheros de autenticación"
cp -v /vagrant/config/tierra/auth/.htpasswd_basic /etc/apache2/
cp -v /vagrant/config/tierra/auth/.htgroups /etc/apache2/
cp -v /vagrant/config/tierra/auth/.htpasswd_digest /etc/apache2/

echo "==> Activando sitio y módulos"
a2dissite 000-default.conf
a2ensite discovery.sistema.sol.conf

a2enmod auth_basic
a2enmod auth_digest

systemctl restart apache2
