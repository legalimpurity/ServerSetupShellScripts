sh basic_server.sh

sudo yum -y install make gcc
sudo yum -y install pcre-devel
sudo yum -y install perl # need to install this now with http installation otherwise php can never be compiled
wget http://www.apache.org/dist/httpd/httpd-2.4.25.tar.gz
wget http://www.us.apache.org/dist/apr/apr-1.5.2.tar.gz
wget http://www.eu.apache.org/dist/apr/apr-util-1.5.4.tar.gz

tar -zxvf httpd-2.4.25.tar.gz
tar -zxvf apr-1.5.2.tar.gz
tar -zxvf apr-util-1.5.4.tar.gz


#1. APR
        cd apr-1.5.2
        ./configure
        make
        sudo make install
        cd ..

#2. APR UTIL
        cd apr-util-1.5.4
        ./configure --with-apr=/usr/local/apr
        make
        sudo make install
        cd ..



cd httpd-2.4.25
./configure --prefix=/legalroot/webserver --enable-so
make
sudo make install

sudo /legalroot/webserver/bin/apachectl start        # will start apache
sudo /legalroot/webserver/bin/apachectl stop # stop for php installation

cd ..
rm -fR httpd-2.4.25
rm -fR httpd-2.4.25.tar.gz
rm -fR apr-1.5.2.tar.gz
rm -fR apr-util-1.5.4.tar.gz
rm -fR apr-1.5.2
rm -fR apr-util-1.5.4

sudo yum -y install firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --add-port=80/tcp
sudo systemctl restart firewalld

echo "sudo vi /legalroot/webserver/conf/httpd.conf"
echo "Options Indexes FollowSymLinks change to ------> Options FollowSymLinks"
echo "AddType  application/x-httpd-php         .php"
