server {
    listen 80 ;
    listen [::]:80;

    root /home/luis/public_html/apilocations/public;
    index index.php index.html index.htm;

    server_name localapilocations.com;

   # nginx configuration
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

  location ~ \.php$ {
        try_files $uri /index.php =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

}
