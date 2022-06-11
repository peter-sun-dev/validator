#!/bin/bash

echo "Installing dependencies..."
echo
echo

# Install dependencies
#sudo apt install wget
wget https://golang.org/dl/go1.18.2.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.18.2.linux-amd64.tar.gz
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile

# Clone and build polygons-sdk

echo "Building Go executable, please wait..."

go install github.com/0xPolygon/polygon-edge@develop && cd /home/$USER/go/bin/
sudo mv polygon-edge /usr/local/bin

# Initialize validator dir
echo "Initializing validator directory.."

/home/$USER/validator && rm -rf data
polygon-edge secrets init --data-dir data
echo
