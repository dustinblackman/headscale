#!/usr/bin/env bash

until [ -f "$KEY_PATH" ]; do
	sleep 0.1
done

sleeptime=$(shuf -i 1-5 -n 1)
echo "Sleeping for $sleeptime before starting tailscale"
sleep "$sleeptime"

tailscaled --tun=userspace-networking --outbound-http-proxy-listen=0.0.0.0:1054 2>/tmp/tailscaled &

if [ -f /var/lib/tailscale/tailscaled.state ]; then
	tailscale up --login-server http://headscale:8080
else
	tailscale up --reset --login-server http://headscale:8080 --auth-key "$(cat "$KEY_PATH")"
fi

nginx_ip=$(tailscale status | grep nginx | grep -v offline | head -n 1 | awk '{print $1}')

while true; do
	curl --max-time 1 -s -x 'http://0.0.0.0:1054/' "http://${nginx_ip}" || echo "Failed to call nginx"
	sleep 3
done
