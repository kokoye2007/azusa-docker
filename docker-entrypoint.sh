#!/usr/azusa/busybox sh
set -e

# run apkg
/usr/azusa/apkg >/var/log/apkg.log 2>&1 </dev/null &

COUNT=0

# wait for mount to happen
while [ ! -f /pkg/main/sys-process.tini.core/bin/tini-static ]; do
	COUNT=$(( $COUNT + 1 ))
	if [ $COUNT -gt 20 ]; then
		echo "Timeout starting to run apkg, giving up"
		echo "apkg's log may be helpful:"
		cat /var/log/apkg.log
		exit 1
	fi
	sleep 0.2
done

exec /pkg/main/sys-process.tini.core/bin/tini-static "$@"
