#! /bin/bash
sudo apt update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
sudo apt update
sudo apt-get install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker ubuntu
sudo docker pull ghcr.io/sithumonline/demedia-benchmark-peer:latest
sudo docker run --name demedia-benchmark-peer -e DATABASE_URL=postgres://nostr:nostr@34.195.250.101:5433/benchmark?sslmode=disable  --network host -d ghcr.io/sithumonline/demedia-benchmark-peer