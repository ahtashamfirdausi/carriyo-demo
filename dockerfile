FROM openjdk:8-jdk

RUN apt-get update -y && apt-get install -y curl sudo

#
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose\
&& chmod +x /usr/local/bin/docker-compose \
&& sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

#docker compose cli
RUN curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose
