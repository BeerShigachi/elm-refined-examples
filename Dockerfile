FROM node:17.0.1-buster-slim

WORKDIR /work

RUN apt update
RUN apt-get install sudo
RUN apt install -y vim
RUN yes | sudo apt install curl

RUN curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz
RUN gunzip elm.gz
RUN chmod +x elm 
RUN sudo mv elm /usr/local/bin/
RUN npm install -g elm-test-rs

ENV PATH $PATH:/usr/local/bin
