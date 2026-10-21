FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl \
    && rm -rf /var/lib/apt/lists/* \
    && rm /etc/nginx/sites-enabled/default \
    && mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
       -keyout /etc/nginx/ssl/inception.key \
       -out /etc/nginx/ssl/inception.crt \
       -subj "/CN=austunso.42.fr"

COPY conf/nginx.conf /etc/nginx/conf.d/inception.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
