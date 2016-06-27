
server {
    listen 80;
    listen [::]:80;
    
    root /home/luis/public_html/maisquitanda;
    index index.php index.html index.htm;

    server_name  localmaisquitanda.com www.localmaisquitanda.com;

location / {
    # This try_files directive is used to enable SEO-friendly URLs for OpenCart
    try_files $uri $uri/ @opencart;
  }

      location /admin {
        index index.php;
    }


    location @opencart {
        rewrite ^/(.+)$ /index.php?_route_=$1 last;
    }
    location = /favicon.ico {
        log_not_found off;
        access_log off;
    }
    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    # Deny all attempts to access hidden files such as .htaccess, .htpasswd, .DS_Store (Mac).
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }
    location ~*  \.(jpg|jpeg|png|gif|css|js|ico)$ {
        expires max;
        log_not_found off;
    }

    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }



    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php5.6-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }


}

