FROM nginx:1.27-alpine

LABEL maintainer="Rajeshkumar Basani"
LABEL project="DevOps 100 Days Challenge"
LABEL day="5"

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
    CMD wget -qO- http://localhost || exit 1