#!/usr/azusa/busybox sh
set -e

# run apkg
/usr/azusa/apkg >/var/log/apkg.log 2>&1 </dev/null &

# wait for mount to happen
while true; do
	if [ -d /pkg/main ]; then
		break
	fi
	# TODO implement timeout
	sleep 0.1
done

exec "$@"
