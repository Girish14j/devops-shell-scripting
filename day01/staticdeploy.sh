#!/bin/bash
set -e

echo "🚀 Deploying Static Resume Website..."

GIT_REPO="https://github.com/Girish14j/resume-ui.git"
PROJECT_DIR="/var/www/resume"
NGINX_ROOT="/var/www/html"

sudo apt update -y
sudo apt install -y git nginx

if [ ! -d "$PROJECT_DIR" ]; then
    git clone $GIT_REPO $PROJECT_DIR
else
    cd $PROJECT_DIR
    git pull
fi

sudo rm -rf $NGINX_ROOT/*
sudo cp -r $PROJECT_DIR/* $NGINX_ROOT/

sudo systemctl restart nginx

echo "✅ Resume Website Deployed Successfully!"

