sudo yum -y clean all
sudo yum -y update
sudo yum -y upgrade
sudo yum -y install screen
sudo yum -y install wget

sudo cp /etc/localtime /root/old.timezone
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
