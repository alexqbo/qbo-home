#!/bin/bash
sudo rm /var/run/docker.sock
sudo ln -s ~/Library/Containers/com.docker.docker/Data/docker.raw.sock /var/run/docker.sock
ls -la /var/run/docker.sock

