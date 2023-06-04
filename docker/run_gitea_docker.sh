#!/bin/bash

echo "*Run gitea on the docker machine"
cp -v /vagrant/docker/docker-compose.yml /home/

docker compose up -d
