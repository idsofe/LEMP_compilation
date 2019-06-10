###Installing require packages 

yum -y update
yum -y install epel-release
yum -y install libtool wget  expat expat-devel libxml2 libxml2-devel perl
yum -y install wget gcc bison re2c gd-devel perl perl-devel perl-ExtUtils-Embed perl-libs zlib-devel openssl-devel geoip geoip-devel libxml2-devel libxslt-devel libmcrypt-devel libjpeg-devel libvpx-devel libcgi-devel libpng-devel libtool-ltdl-devel libnuma* expat-devel libcurl-devel openldap-devel freetype-devel libvpx-devel gettext-devel
yum -y install libaio libaio-devel
yum -y remove mysql-* mariadb-*


###Installing prerequisite packages 
 

cd /opt 
wget https://www-us.apache.org/dist//apr/apr-1.7.0.tar.gz
tar -xzf apr-1.7.0.tar.gz
cd /opt/apr-1.7.0
./configure --prefix=/usr/local/apr
make -j$(nproc)
make install -j$(nproc)


cd /opt
wget https://www-us.apache.org/dist//apr/apr-util-1.6.1.tar.gz
tar -xzf apr-util-1.6.1.tar.gz
cd apr-util-1.6.1
./configure --with-apr=/usr/local/apr
make -j$(nproc)
make install -j$(nproc)



###Installing Apache

cd /opt
wget http://mirrors.viethosting.com/apache//httpd/httpd-2.4.39.tar.gz
tar -xzf httpd-2.4.39.tar.gz
cd /opt/httpd-2.4.39
./configure \
--prefix=/usr \
--exec-prefix=/usr \
--bindir=/usr/bin \
--sbindir=/usr/sbin \
--sysconfdir=/etc/httpd \
--datadir=/var/www/ \
--includedir=/usr/include \
--libdir=/usr/lib64 \
--libexecdir=/usr/libexec \
--localstatedir=/var \
--sharedstatedir=/var/lib \
--mandir=/usr/share/man \
--infodir=/usr/share/info \
--cache-file=../config.cache \
--with-config-file-path=/etc/httpd \
--with-exec-dir=/usr/bin \
--enable-so \
--enable-rewrite \
--enable-systemd \
--enable-expires \
--enable-headers \
--enable-cache \
--enable-mem-cache \
--enable-speling \
--enable-usertrack \
--enable-module=so \
--enable-unique_id \
--enable-logio \
--enable-ssl=shared \
--with-ssl=/usr \
--enable-proxy=shared \
 
make -j$(nproc)
make install -j$(nproc)

cp /opt/LEMP_compilation/apache_modules/* /usr/libexec/

systemctl start httpd







###Installing mysql 5.7.26

yum install -y gcc gcc-c++ cmake ncurses-devel perl perl-devel libaio libaio-devel


groupadd mysql
useradd -r -g mysql -s /bin/false mysql

cd /opt
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.26.tar.gz
tar -xzf mysql-5.7.26.tar.gz
cd mysql-5.7.26
mkdir bld
cd bld
cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/usr/local/mysql -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/boost
make -j$(nproc)
make install -j$(nproc)


cd /usr/local/mysql
mkdir mysql-files
chown mysql:mysql mysql-files
chmod 750 mysql-files
bin/mysqld --initialize --user=mysql > /root/temp_pw_mysql

bin/mysql_ssl_rsa_setup              
bin/mysqld_safe --user=mysql &
# Next command is optional
cp support-files/mysql.server /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld

ln -s /usr/local/mysql/bin/* /usr/sbin/

chkconfig --add mysqld

mv /etc/my.cnf /etc/my.cnf.origin

cp /opt/LEMP_compilation/my.cnf /etc/

mkdir /etc/my.cnf.d

systemctl start mysqld

ln -s /var/lib/mysql/mysql.sock /tmp/mysql.sock


#ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass';



