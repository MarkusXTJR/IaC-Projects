sudo apt update -y
sudo apt install nginx -y
sudo wget https://fllinuxnginxteststore.blob.core.windows.net/scripts/default -O /etc/nginx/sites-available/default 
sudo systemctl restart nginx

# To have DNS resolve the Web Server add an A record that points to the Public IP Address of the webserver, and a CNAME for www that points to the root domain name.