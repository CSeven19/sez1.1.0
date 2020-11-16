sudo echo "29,59 * * * * root sh $(pwd)/cronddir/es_index_nums_crond.sh >> $(pwd)/logs/esnormal.out 2>&1" >> /etc/crontab
systemctl reload crond &&
systemctl restart crond
