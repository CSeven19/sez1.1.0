echo "----------运行开始----------"
./portrelease.sh
./start_sba.sh && ./start_elk.sh && ./start_zabbix.sh
echo "----------运行结束----------"
