#!/bin/sh
echo "Starting"
echo -e "test" | sudo -S crond -f -c /var/spool/cron/crontabs -l 5 -L /dev/stdout | awk '{print "[" strftime("%Y-%m-%d %H:%M:%S") "]", $0}' > /Logs/cron.log
tail -f /dev/null
echo 'Exiting'
