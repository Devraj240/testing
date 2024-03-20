FROM nginx:latest


RUN rm -rf /etc/nginx/conf.d/default.conf

RUN service nginx restart 

COPY nginx.conf /etc/nginx/conf.d/
COPY index.html /usr/share/nginx/html/
EXPOSE 8001


