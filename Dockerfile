FROM        debian:wheezy
#FROM        ubuntu:14.10
MAINTAINER  Liverbool "nukboon@gmail.com"

RUN apt-get update && apt-get -y install wget

RUN echo "deb http://packages.dotdeb.org wheezy-php56 all" >> /etc/apt/sources.list
RUN echo "deb-src http://packages.dotdeb.org wheezy-php56 all" >> /etc/apt/sources.list

RUN wget http://www.dotdeb.org/dotdeb.gpg -O- |apt-key add -

RUN apt-get update

# Install PHP5 and modules along with composer binary
RUN apt-get -y install php5-fpm php5-pgsql php-apc php5-mcrypt php5-curl php5-gd php5-json php5-cli php5-intl libssh2-php
RUN sed -i -e "s/short_open_tag = Off/short_open_tag = On/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size = 8M/post_max_size = 20M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" /etc/php5/fpm/php.ini
RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN echo "max_input_vars = 10000;" >> /etc/php5/fpm/php.ini
RUN echo "date.timezone = Asia/Bangkok;" >> etc/php5/fpm/php.ini

RUN sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php5/fpm/php-fpm.conf
RUN sed -e 's/;listen\.owner/listen.owner/' -i /etc/php5/fpm/pool.d/www.conf
RUN sed -e 's/;listen\.group/listen.group/' -i /etc/php5/fpm/pool.d/www.conf

# Setup supervisor
RUN apt-get install -y supervisor
ADD supervisor/php.conf /etc/supervisor/conf.d/

# Internal Port Expose
EXPOSE 9000

RUN php -v
CMD ["/usr/bin/supervisord", "-n"]
