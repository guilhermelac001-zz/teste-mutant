FROM phusion/baseimage:master

WORKDIR /

COPY install_applications.sh .

RUN ./install_applications.sh

COPY bitbucket_manager.py .