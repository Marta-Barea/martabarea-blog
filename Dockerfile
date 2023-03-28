FROM nginx:1.22.1

COPY default.conf /etc/nginx/conf.d/default.conf
COPY ./martabarea-blog/public/ /var/www/martabarea-blog/

CMD ["nginx", "-g", "daemon off;"]