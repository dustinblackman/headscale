#!/usr/bin/env bash

until [ -f /node-keys/machine-nginx ]; do
	sleep 0.1
done

tailscaled --tun=userspace-networking 2>/tmp/tailscaled &

if [ -f /var/lib/tailscale/tailscaled.state ]; then
	tailscale up --login-server http://headscale:8080
else
	tailscale up --reset --login-server http://headscale:8080 --auth-key "$(cat /node-keys/machine-nginx)"
fi

nginx -g 'daemon off;'
