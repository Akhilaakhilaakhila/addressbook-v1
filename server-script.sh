#! /bin/bash
# sudo yum install java-1.8.0-openjdk-devel -y
sudo yum install git -y
# sudo yum install maven -y
sudo yum install docker -y
sudo systemctl start docker

if [ -d "addressbook-v1" ]
then
  echo "repo is cloned and exists"
  cd /home/ec2-user/addressbook-v1
  git pull origin tf-cicd
else
  git clone https://github.com/Akhilaakhilaakhila/addressbook-v1.git
fi
cd /home/ec2-user/addressbook-v1
git checkout tf-cicd
sudo docker build -t $1:$2 /home/ec2-user/addressbook-v1
