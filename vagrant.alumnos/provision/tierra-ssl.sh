#!/bin/bash
set -e

echo "==> Instalando soporte SSL"
apt-get update
apt-get install -y openssl

echo "==> Habilitando módulo SSL"
a2enmod ssl

echo "==> Asegurando puerto 443"
grep -q "Listen 443" /etc/apache2/ports.conf || echo "Listen 443" >> /etc/apache2/ports.conf

echo "==> Copiando VirtualHost HTTPS"
cp -v /vagrant/config/tierra/discovery.sistema.sol-ssl.conf \
      /etc/apache2/sites-available/

echo "==> Creando directorio de certificados"
mkdir -p /etc/apache2/ssl

echo "==> Generando certificado autofirmado"
openssl req -x509 -nodes -days 365 \
-newkey rsa:2048 \
-keyout /etc/apache2/ssl/discovery.key \
-out /etc/apache2/ssl/discovery.crt \
-subj "/C=ES/ST=Granada/L=Granada/O=IES/OU=ASIR/CN=discovery.sistema.sol"

echo "==> Activando sitio HTTPS"
a2ensite discovery.sistema.sol-ssl.conf

echo "==> Reiniciando Apache"
systemctl restart apache2
