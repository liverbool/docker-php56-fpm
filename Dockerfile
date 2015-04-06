FROM        debian:wheezy
#FROM        ubuntu:14.10
MAINTAINER  Liverbool "nukboon@gmail.com"

RUN apt-get update

# Install PHP5 and modules along with composer binary
RUN apt-get -y install php5-fpm php5-pgsql php-apc php5-mcrypt php5-curl php5-gd php5-json php5-cli php5-intl libssh2-php
RUN sed -i -e "s/short_open_tag = Off/short_open_tag = On/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size = 8M/post_max_size = 20M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" /etc/php5/fpm/php.ini
RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN echo "max_input_vars = 10000;" >> /etc/php5/fpm/php.ini
RUN echo "date.timezone = Asia/Bangkok;" >> etc/php5/fpm/php.ini

# Setup supervisor
RUN apt-get install -y supervisor
ADD supervisor/php.conf /etc/supervisor/conf.d/


# Internal Port Expose
EXPOSE 9000

CMD ["/usr/bin/supervisord", "-n"]
