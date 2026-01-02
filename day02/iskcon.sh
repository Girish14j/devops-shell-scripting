#!/bin/bash

set -e

APP_NAME="iskcon-website"
APP_DIR="/var/www/$APP_NAME"
REPO_URL="https://github.com/Girish14j/Iskcon-bhakti-booking.git"

echo "🚀 Starting deployment for $APP_NAME"

# 1️⃣ Install required packages (only first time)
echo "📦 Installing required packages..."
sudo apt update -y
sudo apt install -y nginx nodejs npm git

# 2️⃣ Remove old build (if exists)
echo "🧹 Cleaning old deployment..."
sudo rm -rf $APP_DIR

# 3️⃣ Clone repository
echo "📥 Cloning repository..."
sudo git clone $REPO_URL $APP_DIR

cd $APP_DIR

# 4️⃣ Install dependencies
echo "📦 Installing npm dependencies..."
npm install

# 5️⃣ Create .env file for Supabase
echo "🔐 Creating environment variables..."
cat <<EOF > .env
VITE_SUPABASE_URL=https://zpqvsedngdmzaeuorhxt.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpwcXZzZWRuZ2RtemFldW9yaHh0Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NDAyNzg0MiwiZXhwIjoyMDU5NjAzODQyfQ.tU8QWRTkiFaoW7n18OyQUOd1yR4AtEYdya2Etx9hUjQ
EOF

# 6️⃣ Build project
echo "🏗️ Building Vite project..."
npm run build

# 7️⃣ Configure Nginx
echo "🌐 Configuring Nginx..."
sudo tee /etc/nginx/sites-available/$APP_NAME > /dev/null <<EOF
server {
    listen 80;
    server_name _;

    root $APP_DIR/dist;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

# 8️⃣ Enable site
sudo ln -sf /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# 9️⃣ Restart Nginx
echo "🔄 Restarting Nginx..."
sudo nginx -t
sudo systemctl restart nginx

echo "✅ Deployment successful!"
echo "🌍 Visit your site using server IP or domain"

