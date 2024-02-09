#!/usr/bin/env bash

air \
	--build.cmd "go build -o /usr/bin/headscale -a ./cmd/headscale" \
	--build.bin="/usr/bin/headscale serve" \
	--build.exclude_dir=tools/local-cluster/.cache &

until curl -s --max-time 0.3 http://localhost:8080/health; do
	sleep 0.1
done

headscale user list -o json | grep -q machine-nginx || headscale user create machine-nginx
headscale user list -o json | grep -q machine-normal || headscale user create machine-normal
headscale user list -o json | grep -q machine-ephemeral || headscale user create machine-ephemeral

rm -f /node-keys/*
headscale preauthkeys create -u machine-nginx >/node-keys/machine-nginx
headscale preauthkeys create -u machine-normal --reusable >/node-keys/machine-normal
headscale preauthkeys create -u machine-ephemeral --reusable --ephemeral >/node-keys/machine-ephemeral

wait
