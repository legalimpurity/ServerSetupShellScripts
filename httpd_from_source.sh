sh basic_server.sh

sudo yum -y install make gcc
sudo yum -y install pcre-devel
sudo yum -y install perl # need to install this now with http installation otherwise php can never be compiled
sudo yum install expat-devel # for apr-util

httpdV="httpd-2.4.29"
aprV="apr-1.6.3"
aprUtilV="apr-util-1.6.1"
genericFooter=".tar.gz"
installationFolder="/legalroot/webserver"

#save yourself from apr-util errormsg
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8


if [ ! -d "$installationFolder" ]; then
  sudo mkdir -p $installationFolder
fi
wget "http://www.apache.org/dist/httpd/$httpdV$genericFooter"
wget "http://www.us.apache.org/dist/apr/$aprV$genericFooter"
wget "http://www.eu.apache.org/dist/apr/$aprUtilV$genericFooter"

tar -zxvf $httpdV$genericFooter
tar -zxvf $aprV$genericFooter
tar -zxvf $aprUtilV$genericFooter


#1. APR
        cd "$aprV"
        ./configure  --prefix=/usr/local/apr
        make
        sudo make install
        cd ..

#2. APR UTIL
        cd "$aprUtilV"
        ./configure --with-apr=/usr/local/apr
        make
        sudo make install
        cd ..



cd "$httpdV"
./configure --prefix="$installationFolder" --enable-so
make
sudo make install

sudo "$installationFolder/bin/apachectl" start        # will start apache
sudo "$installationFolder/bin/apachectl" stop # stop for php installation

cd ..
rm -fR $httpdV
rm -fR $httpdV$genericFooter
rm -fR $aprV
rm -fR $aprV$genericFooter
rm -fR $aprUtilV
rm -fR $aprUtilV$genericFooter

sudo yum -y install firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --add-port=80/tcp
sudo systemctl restart firewalld

echo "sudo vi $installationFolder/conf/httpd.conf"
echo "Options Indexes FollowSymLinks change to ------> Options FollowSymLinks"
echo "AddType  application/x-httpd-php         .php"
