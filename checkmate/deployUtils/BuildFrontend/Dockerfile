FROM node:latest

WORKDIR /usr/src

COPY "docker-entrypoint.sh" /usr/src/
RUN chmod +x ./docker-entrypoint.sh

ENTRYPOINT [ "./docker-entrypoint.sh" ]
