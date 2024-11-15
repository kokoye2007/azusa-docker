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

#!/usr/azusa/busybox sh
set -e

# Start apkg daemon in the background and log output
/usr/azusa/apkg >/var/log/apkg.log 2>&1 </dev/null &

wait_interval=0.5  # seconds
elapsed_time=0

# Use `until` to wait for the specific log message indicating readiness
until /usr/azusa/busybox grep -q "ctrl: control socket ready" /var/log/apkg.log; do
    #echo "Waiting for apkg to be ready..."
    sleep "$wait_interval"
    clear
    elapsed_time=$(echo "$elapsed_time + $wait_interval" | bc)
    echo "$elapsed_time"
    tail -n 5 /var/log/apkg.log
done

echo -e '
      ___                         ____  _____
     /   |____  __  ___________ _/ __ \/ ___/
    / /| /_  / / / / / ___/ __ `/ / / /\__ \
   / ___ |/ /_/ /_/ (__  ) /_/ / /_/ /___/ /
  /_/  |_/___/\__,_/____/\__,_/\____//____/
        https://github.com/AzusaOS

'

# Execute tini-static with passed arguments once the file is available
exec /pkg/main/sys-process.tini.core/bin/tini-static "$@"
