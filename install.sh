#!/bin/bash
#
# Build Web Application
# Task for Aditya
#

mkdir -p /srv/www/yii2
mkdir -p /srv/www/wordpress
chown -R root:root /srv/www/yii2
chown -R root:root /srv/www/wordpress
chmod -R 755 /srv/www

cd /
wget https://raw.githubusercontent.com/adityadwi4/99/master/wordpress-index
https://raw.githubusercontent.com/adityadwi4/99/master/yii2-index
mv wordpress-index /srv/www/wordpress/index.html
mv yii2-index /srv/www/yii2/index.html

NGINX_SITES_AVAILABLE="/etc/nginx/sites-available"
NGINX_SITES_ENABLED="/etc/nginx/sites-enabled"

cd $NGINX_SITES_AVAILABLE

wget https://raw.githubusercontent.com/adityadwi4/99/master/wordpress
wget https://raw.githubusercontent.com/adityadwi4/99/master/yii2

ln -s /etc/nginx/sites-available/yii2 /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

service nginx reload
service nginx restart
