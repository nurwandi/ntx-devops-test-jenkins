#!/bin/bash

NODE_APP_DIRECTORY="$WORKSPACE/nurwandi-ntx-devops-test"

pwd

cd "$NODE_APP_DIRECTORY" || exit
echo "Now inside the directory: $NODE_APP_DIRECTORY"

TIMESTAMP=$(date +"%m.%d.%Y")

docker build -t nurwandi7/ntx-devops-test:$TIMESTAMP .

sudo apt update
sudo apt install -y docker.io

sudo systemctl enable docker
sudo systemctl start docker

sudo systemctl status docker

sudo service docker start

sudo usermod -aG docker $USER


exit
