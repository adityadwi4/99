#!/bin/bash
#
# Build Web Application
# Task for Aditya
#

mkdir -p /srv/www/yii2
mkdir -p /srv/www/wordpress
chown -R $USER:$USER /srv/www/yii2
chown -R $USER:$USER /srv/www/wordpress
chmod -R 755 /srv/www

NGINX_CONF_DIR="deploy/docker/nginx"
NGINX_SITES_AVAILABLE="/etc/nginx/sites-available"
NGINX_SITES_ENABLED="/etc/nginx/sites-enabled"

cd $NGINX_SITES_AVAILABLE

wget https://raw.githubusercontent.com/adityadwi4/99/master/wordpress
wget https://raw.githubusercontent.com/adityadwi4/99/master/yii2

cd /
mv /wordpress /srv/www/wordpress

ln -s /etc/nginx/sites-available/yii2 /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

if [ ! -f /srv/www/wordpress/wp-config.php ]; then
#mysql has to be started this way as it doesn't work to call from /etc/init.d
/usr/bin/mysqld_safe & 
sleep 10s
# Here we generate random passwords (thank you pwgen!). The first two are for mysql users, the last batch for random keys in wp-config.php
WORDPRESS_DB="wordpress"
MYSQL_PASSWORD=`pwgen -c -n -1 12`
WORDPRESS_PASSWORD=`pwgen -c -n -1 12`
#This is so the passwords show up in logs. 
echo mysql root password: $MYSQL_PASSWORD
echo wordpress password: $WORDPRESS_PASSWORD
echo $MYSQL_PASSWORD > /mysql-root-pw.txt
echo $WORDPRESS_PASSWORD > /wordpress-db-pw.txt
#there used to be a huge ugly line of sed and cat and pipe and stuff below,
#but thanks to @djfiander's thing at https://gist.github.com/djfiander/6141138
#there isn't now.

sed -e "s/database_name_here/$WORDPRESS_DB/
s/username_here/$WORDPRESS_DB/
s/password_here/$WORDPRESS_PASSWORD/
/'AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'SECURE_AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'LOGGED_IN_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'NONCE_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'SECURE_AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'LOGGED_IN_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'NONCE_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/" /var/www/wp-config-sample.php > /var/www/wp-config.php

chown www-data:www-data /srv/www/wordpress/wp-config.php
cd /srv/www/wordpress
mkdir wp-content-ugrade
find /srv/www/wordpress -type d -exec chmod g+s {} \;
chmod g+w /srv/www/wordpress/wp-content
chmod -R g+w /srv/www/wordpress/wp-content/themes
chmod -R g+w /srv/www/wordpress/wp-content/plugins
cd /

mysqladmin -u root password $MYSQL_PASSWORD 
mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE wordpress; GRANT ALL ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY '$WORDPRESS_PASSWORD'; FLUSH PRIVILEGES;"
killall mysqld
sleep 10s
fi

sed -e "s/enter your secret key here/$WORDPRESS_PASSWORD/" /srv/www/yii2/config/web.php
#nano /etc/nginx/nginx.conf

#server_names_hash_bucket_size 64;
service nginx reload
service nginx restart
