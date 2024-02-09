FROM golang:1.22-bookworm

RUN apt-get update && apt-get install -y curl
RUN go install github.com/cosmtrek/air@latest

RUN mkdir -p /var/run/headscale /var/lib/headscale

WORKDIR /app
