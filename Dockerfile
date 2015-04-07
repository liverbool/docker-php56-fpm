FROM        debian:wheezy
#FROM        ubuntu:14.10
MAINTAINER  Liverbool "nukboon@gmail.com"

RUN echo "deb http://packages.dotdeb.org wheezy all" >> /etc/apt/sources.list
RUN echo "deb-src http://packages.dotdeb.org wheezy all" >> /etc/apt/sources.list

RUN apt-get -y install wget

RUN wget http://www.dotdeb.org/dotdeb.gpg
RUN apt-key -y add dotdeb.gpg

RUN apt-get update

# Install PHP5 and modules along with composer binary
RUN apt-get -y install php56-fpm php56-pgsql php-apc php56-mcrypt php56-curl php56-gd php56-json php56-cli php56-intl libssh2-php
RUN sed -i -e "s/short_open_tag = Off/short_open_tag = On/g" /etc/php56/fpm/php.ini
RUN sed -i -e "s/post_max_size = 8M/post_max_size = 20M/g" /etc/php56/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" /etc/php56/fpm/php.ini
RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php56/fpm/php.ini
RUN echo "max_input_vars = 10000;" >> /etc/php56/fpm/php.ini
RUN echo "date.timezone = Asia/Bangkok;" >> etc/php56/fpm/php.ini

RUN sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php56/fpm/php-fpm.conf
RUN sed -e 's/;listen\.owner/listen.owner/' -i /etc/php56/fpm/pool.d/www.conf
RUN sed -e 's/;listen\.group/listen.group/' -i /etc/php56/fpm/pool.d/www.conf

# Setup supervisor
RUN apt-get install -y supervisor
ADD supervisor/php.conf /etc/supervisor/conf.d/


# Internal Port Expose
EXPOSE 9000

CMD ["/usr/bin/supervisord", "-n"]
