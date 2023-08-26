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
  ipfs: https://ipfs.io/ipfs/QmcZFshahydS7RTuT11fw9BZc7Wto35BvmYgZg4gBd99BM
  rest: https://pkg.go.dev/static/shared/gopher/airplane-1200x945.svg

- id: 2
  name: Image 02
  ipfs: https://ipfs.io/ipfs/QmcZFshahydS7RTuT11fw9BZc7Wto35BvmYgZg4gBd99BM
  rest: https://pkg.go.dev/static/shared/gopher/airplane-1200x945.svg
EOF

sudo docker run --name demedia-benchmark-client --network host -e PEER_ADDRESS=/ip4/${peer_priv_ip}/tcp/10880/p2p/16Uiu2HAm11tBBtFMubGtVWty12oYHzq58k7p3ZfdPhe24qgKVgX7 -e PEER_REST_ENDPOINT=http://${peer_priv_ip}:8080/getAllItem -v ./config.yaml:/config.yaml -d ghcr.io/sithumonline/demedia-benchmark-client
