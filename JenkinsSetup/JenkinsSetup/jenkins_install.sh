#!/bin/sh


yum install epel-release -y
yum update -y


yum install java-11-openjdk-devel tree wget -y
dnf -y install maven

echo "Installing GIT Client..."
sudo yum install git -y
sleep 10


echo "Installing Jenkins..."
sudo update-alternatives --set java java-11-openjdk.x86_64
java -version
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key
yum upgrade -y 
yum install jenkins -y

systemctl stop jenkins

sed 's/#TimeoutStartSec=90/TimeoutStartSec=480/g' /usr/lib/systemd/system/jenkins.service > /tmp/jenkins.service
cp -fr /tmp/jenkins.service /usr/lib/systemd/system/jenkins.service
systemctl daemon-reload
systemctl restart jenkins
systemctl enable jenkins


sleep 20

usermod --shell /bin/bash jenkins
echo "jenkins  ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

sleep 10
systemctl restart jenkins
echo "Access Jenkins http://IPAddress:8080/ with user name admin and password from /var/lib/jenkins/secrets/initialAdminPassword"