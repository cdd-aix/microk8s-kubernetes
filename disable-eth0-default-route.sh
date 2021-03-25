#!/bin/bash -eu
case "${interface:-eth0}" in
    eth0)
	echo "executing ip route delete default via ${new_routers:-127.0.0.1}"
	ip route delete default via "${new_routers:-127.0.0.1}"
	;;
esac
