#!/usr/bin/env bash
# This script sets up web servers for the AirBnB Clone - Deploy Static project

# Check if Nginx is installed, and install it if not
if ! dpkg -l nginx >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get -y install nginx
fi

# Create all directories and subdirectories for the static files
sudo mkdir -p /data/web_static/shared/
sudo mkdir -p /data/web_static/releases/test/

html_data="<html>
  <head>
  </head>
  <body>
    <h1>Welcome to Nehad Tech!</h1>
    <p>This is a test page</p>
  </body>
</html>"

# Create a test html file
echo "${html_data}" | sudo tee /data/web_static/releases/test/index.html > /dev/null

# Create or recreate the symbolic link (deleting the existing one if it exists)
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Change owner and group for for the `/data/` directory
sudo chown -R ubuntu:ubuntu /data/

# Configuration to add
config_to_add="    location /hbnb_static/ {
        alias /data/web_static/current/;
        index index.html;
        # Enable directory listing (if desired)
        # autoindex on;
    }"

# Path to the Nginx configuration file
nginx_config="/etc/nginx/sites-available/default"


# Check if the configuration already exists
if ! grep -q "location /hbnb_static/" "$nginx_config"; then
    # Configuration does not exist, add it using awk
    sudo awk -v config="$config_to_add" '/^}$/ {print config} {print} ' "$nginx_config" > temp && mv temp "$nginx_config"
    # sudo awk -v config="$config_to_add" '/^}$/ {print config} {print} ' "$nginx_config" | sudo tee "$nginx_config" > /dev/null

    echo "Configuration added."
else
    echo "Configuration already exists."
fi

sudo service nginx restart
