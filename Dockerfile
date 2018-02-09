FROM ubuntu:latest
MAINTAINER Aditya Dwi <adityadwi4@gmail.com>
RUN apt-get update
RUN apt-get -y install wget nano nginx php-fpm
ADD https://raw.githubusercontent.com/adityadwi4/99/master/install.sh /install.sh
RUN chmod 755 /install.sh
EXPOSE 8001
EXPOSE 8002
CMD ["/bin/bash", "/install.sh"]
