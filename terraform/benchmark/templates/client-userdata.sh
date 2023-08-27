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
sudo docker pull ghcr.io/sithumonline/demedia-benchmark-client:latest
sudo cat <<EOF >> config.yaml
runs:
- id: 1
  name: Image 01
  ipfs: https://ipfs.io/ipfs/QmYCsstLojaQyvksVAF2MAN4FpLKyiK8kajheZMs3SkS9o
  rest: https://files.mastodon.social/media_attachments/files/110/960/728/298/000/618/original/348662e4dde23114.jpg

- id: 2
  name: Image 02
  ipfs: https://ipfs.io/ipfs/QmS43ZkSrpVJU1YTYAXXQxqjP57DFF9SzshRHFaZ8qpYUB
  rest: https://files.mastodon.social/media_attachments/files/110/960/726/296/848/902/original/de537b0ff31c9575.jpg
EOF

sudo docker run --name demedia-benchmark-client --network host -e PEER_ADDRESS=/ip4/${peer_priv_ip}/tcp/10880/p2p/16Uiu2HAm11tBBtFMubGtVWty12oYHzq58k7p3ZfdPhe24qgKVgX7 -e PEER_REST_ENDPOINT=http://${peer_priv_ip}:8080/getAllItem -e DATABASE_URL=postgres://nostr:nostr@34.195.250.101:5433/benchmark?sslmode=disable -v ./config.yaml:/config.yaml -d ghcr.io/sithumonline/demedia-benchmark-client
