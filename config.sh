#!/bin/bash

## install docker 
sudo yum update -y

sudo yum install docker -y 

sudo service docker start

sudo usermod -a -G docker ec2-user 


# Install awscli

mkdir ~/.aws

cd ~/ .aws

touch credentials
touch config

echo "[default]
aws_access_key_id = AKIAU6GDU7T64MA2BIVW
aws_secret_access_key = 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 >> credentials

echo "[default]
region = us-east-1" >> config


## install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

