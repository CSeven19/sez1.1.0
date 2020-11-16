sudo echo "59 23 * * * root sh $(pwd)/cronddir/es_data_clear_crond.sh $1 >> $(pwd)/logs/esdeletelog.out 2>&1" >> /etc/crontab
systemctl reload crond &&
systemctl restart crond
