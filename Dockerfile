FROM ubuntu:latest
MAINTAINER Aditya Dwi <adityadwi4@gmail.com>
RUN apt-get update
RUN apt-get -y install wget curl nano nginx mysql-client mysql-server php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc pwgen
ADD https://wordpress.org/latest.tar.gz /latest.tar.gz
RUN tar xvf latest.tar.gz && rm latest.tar.gz
ADD https://github.com/yiisoft/yii2/releases/download/2.0.13/yii-basic-app-2.0.13.tgz
RUN tar xvzf yii-basic-app-2.0.13.tgz.3
RUN mv /basic /srv/www/yii2
ADD https://raw.githubusercontent.com/adityadwi4/99/master/install.sh /install.sh
RUN tar xvzf /wordpress.tar.gz 
RUN chown -R www-data:www-data /var/www/
RUN chmod 755 /install.sh
EXPOSE 8001
EXPOSE 8002
CMD ["/bin/bash", "/install.sh"]
