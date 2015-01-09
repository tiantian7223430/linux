#!/bin/bash

if [ -x `which yum` ];then
	echo "Please waiting ..."
else
	echo "Sorry,your system wasn't match!!!"
	exit 0
fi

function Yum() {
	[ `rpm -qa|grep epel|grep -v 'grep'` -eq 0 ] && rpm -ivh http://mirrors.zju.edu.cn/epel/6/x86_64/epel-release-6-8.noarch.rpm    
	yum -y install gcc wget libjpeg-devel libpng-devel mysql-devel libicu-devel libxml2-devel bzip2-devel libmcrypt-devel openssl-devel libcurl-devel
}

function Config() {
	ln -s /usr/lib64/mysql/libmysqlclient.so /usr/lib/
}

function InstallPHP55 {
wget http://mirrors.sohu.com/php/php-5.5.17.tar.bz2
if [ $? -eq 0 ];then
	tar jxf php-5.5.17.tar.bz2
	cd php-5.5.17
	./configure --prefix=/usr/local/php55 --with-config-file-path=/usr/local/php55/etc \
	--with-config-file-scan-dir=/usr/local/php55/etc/php.d --enable-bcmath --enable-exif \
	--enable-sockets --enable-mbstring --enable-fpm --enable-soap --with-mcrypt --with-bz2 \
	--with-openssl --with-zlib --with-mhash --with-mysql --with-mysqli --with-pdo-mysql \
	--with-curl
	make
	make install
	cp php.ini-production /usr/local/php55/etc/php.ini
	cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
	chmod u+x /etc/init.d/php-fpm
	cp /usr/local/php55/etc/php-fpm.conf.default /usr/local/php55/etc/php-fpm.conf
	[ -d /usr/local/php55/etc/php.d ] || mkdir /usr/local/php55/etc/php.d
fi

function InstallPHP53 {
wget http://mirrors.sohu.com/php/php-5.3.28.tar.gz
if [ $? -eq 0 ];then
	tar jxf php-5.3.28.tar.gz
	cd php-5.3.28
	./configure --prefix=/usr/local/php53 --with-config-file-path=/usr/local/php53/etc \
	--with-config-file-scan-dir=/usr/local/php53/etc/php.d --enable-bcmath --enable-exif \
	--enable-sockets --enable-mbstring --enable-fpm --enable-soap --with-mcrypt --with-bz2 \
	--with-openssl --with-zlib --with-mhash --with-mysql --with-mysqli --with-pdo-mysql \
	--with-curl --with-gd --with-jpeg-dir --with-png-dir   
	make
	make install
	cp php.ini-production /usr/local/php53/etc/php.ini
	cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
	chmod u+x /etc/init.d/php-fpm
	cp /usr/local/php53/etc/php-fpm.conf.default /usr/local/php53/etc/php-fpm.conf
	[ -d /usr/local/php53/etc/php.d ] || mkdir /usr/local/php53/etc/php.d
fi
}


#install extension
function Extension() {
	cd ~
	tar zxf intl-3.0.0.tgz
	cd intl-3.0.0
	phpize
	./configure --enable-intl
	make && make install
	echo "extension=intl.so" >> /usr/local/php55/etc/php.d/extension.ini
	cd ..
	
	wget http://pecl.php.net/get/memcache-3.0.8.tgz
	tar zxf memcache-3.0.8.tgz
	cd memcache-3.0.8
	phpize
	./configure --enable-memcache
	make && make install
	echo "extension=memcache.so" >> /usr/local/php55/etc/php.d/extension.ini
	cd ..
	
	wget http://pecl.php.net/get/redis-2.2.5.tgz
	tar zxf redis-2.2.5.tgz
	phpize
	./configure
	make && make install
	echo "extension=redis.so" >> /usr/local/php55/etc/php.d/extension.ini
	cd ..
}
