#!/bin/bash

# Exit immediately if any command fails
set -e

echo "🚀 Starting Deployment..."

# VARIABLES (change as per your project)
APP_NAME="Keeper_app"
APP_DIR="/var/www/resume"
GIT_REPO="https://github.com/Girish14j/resume-ui.git"
BRANCH="main"
PORT=3000

# STEP 1: Update system
echo "🔄 Updating system packages..."
sudo apt update -y

# STEP 2: Install required tools
echo "📦 Installing required packages..."
sudo apt install -y git nodejs npm

# STEP 3: Clone or update repository
if [ ! -d "$APP_DIR" ]; then
    echo "📁 Cloning repository..."
    sudo git clone -b $BRANCH $GIT_REPO $APP_DIR
else
    echo "🔄 Pulling latest changes..."
    cd $APP_DIR
    sudo git pull origin $BRANCH
fi

# STEP 4: Install dependencies
echo "📦 Installing project dependencies..."
cd $APP_DIR
sudo npm install

# STEP 5: Build project (for React / frontend apps)
echo "🏗️ Building project..."
sudo npm run build || echo "No build step found, skipping..."

# STEP 6: Stop existing app (if running)
echo "🛑 Stopping existing app..."
sudo pm2 stop $APP_NAME || echo "App not running"

# STEP 7: Start app using PM2
echo "▶️ Starting app..."
sudo pm2 start npm --name "$APP_NAME" -- start

# STEP 8: Save PM2 process
sudo pm2 save

echo "✅ Deployment completed successfully!"

