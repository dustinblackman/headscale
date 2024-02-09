FROM golang:1.22-bookworm

RUN apt-get update && apt-get install -y curl nginx
RUN curl -fsSL https://tailscale.com/install.sh | sh
