
server {
    listen 80;
    listen [::]:80;
    
    root /home/luis/public_html/fegaray/;
    index index.php index.html index.htm;

    server_name  localfegaray.com www.localfegaray.com;



# nginx configuration
location / {
if ($http_host ~ "^www\.(.*)"){
rewrite ^(.*)$ http://%1/$1 redirect;
}
rewrite ^/([^/.]+)/$ /index.php?idioma=$1&view=$2;
rewrite ^/([^/.]+)$ /index.php?idioma=$1&view=$2;
rewrite ^/([^/.]+)/([^/.]+)/?$ /index.php?idioma=$1&view=$2&param1=$3;
rewrite ^/([^/.]+)/([^/.]+)?$ /index.php?idioma=$1&view=$2&param1=$3;
rewrite ^/([^/.]+)/([^/.]+)/([^/.]+)/?$ /index.php?idioma=$1&view=$2&param1=$3&param2=$4;
rewrite ^/([^/.]+)/([^/.]+)/([^/.]+)?$ /index.php?idioma=$1&view=$2&param1=$3&param2=$4;
rewrite ^/([^/.]+)/([^/.]+)/([^/.]+)/([^/.]+)/?$ /index.php?idioma=$1&view=$2&param1=$3&param2=$4&param3=$5;
rewrite ^/([^/.]+)/([^/.]+)/([^/.]+)/([^/.]+)?$ /index.php?idioma=$1&view=$2&param1=$3&param2=$4&param3=$5;
}
location = /gestor {
rewrite ^(.*)$ /gestor/index.php;
}
location /gestor {
rewrite ^/gestor/([^/.]+)/$ /gestor/index.php?controller=$1;
rewrite ^/gestor/([^/.]+)$ /gestor/index.php?controller=$1;
rewrite ^/gestor/([^/.]+)/([^/.]+)/?$ /gestor/index.php?controller=$1&view=$2;
rewrite ^/gestor/([^/.]+)/([^/.]+)?$ /gestor/index.php?controller=$1&view=$2;
rewrite ^/gestor/([^/.]+)/([^/.]+)/([^/.]+)/?$ /gestor/index.php?controller=$1&view=$2&action=$3;
rewrite ^/gestor/([^/.]+)/([^/.]+)/([^/.]+)?$ /gestor/index.php?controller=$1&view=$2&action=$3;
rewrite ^/gestor/([^/.]+)/([^/.]+)/([^/.]+)/([^/.]+)/?$ /gestor/index.php?controller=$1&view=$2&action=$3&parametro=$4;
rewrite ^/gestor/([^/.]+)/([^/.]+)/([^/.]+)/([^/.]+)?$ /gestor/index.php?controller=$1&view=$2&action=$3&parametro=$4;
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

