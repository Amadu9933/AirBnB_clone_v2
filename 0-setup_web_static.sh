#!/usr/bin/env bash

# Install Nginx if it's not already installed
if [ $(which nginx) ]; then
    echo "Nginx already installed."
else
    sudo apt-get update
    sudo apt-get -y install nginx
fi

# Create necessary directories if they don't exist
sudo mkdir -p /data/web_static/releases/test/
sudo mkdir -p /data/web_static/shared/
sudo touch /data/web_static/releases/test/index.html
echo "Hello World" | sudo tee /data/web_static/releases/test/index.html

# Create symbolic link
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Give ownership of /data/ to ubuntu user and group
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config="location /hbnb_static/ {\n\talias /data/web_static/current/;\n\tindex index.html;\n}\n"
sudo sed -i "37i $config" /etc/nginx/sites-available/default

# Restart Nginx
sudo service nginx restart

