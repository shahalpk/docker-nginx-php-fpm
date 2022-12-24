#!/bin/bash
cd /var/www/app

npm run build
php artisan storage:link
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan event:cache

# Update nginx to match worker_processes to no. of cpu's
procs=$(cat /proc/cpuinfo | grep processor | wc -l)
sed -i -e "s/worker_processes  1/worker_processes $procs/" /etc/nginx/nginx.conf

# Always chown webroot for better mounting
echo 'Updating owner:group of /var/www/app to nginx:nginx'
chown -Rf nginx:nginx /var/www/app


# Start supervisord and services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf
