#!/bin/sh
echo "Starting"
echo -e "test" | sudo -S crond -f -c /var/spool/cron/crontabs -L /Logs/cron.log
tail -f /Logs/cron.log
echo 'Exiting'
