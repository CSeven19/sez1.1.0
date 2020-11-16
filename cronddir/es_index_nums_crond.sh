shijian=`date +%Y.%m.%d`
echo ${shijian}
indexinfo=$(curl -GET "0.0.0.0:9200/_cat/indices/logstash-${shijian}")
if [ -n "${indexinfo}" ];then
	indexinfoarray=(${indexinfo// / })
	echo ${indexinfoarray[6]}
	if [ ${indexinfoarray[6]} -gt 1600000000 ];then
		echo "Warning:${shijian}:" "日志存储数量超过elasticsearch数据库索引存储上限的80%" >> ../logs/esnormal.out 2>&1
	fi
	if [ ${indexinfoarray[6]} -gt 1800000000 ];then
		echo "Warning:${shijian}:" "日志存储数量超过elasticsearch数据库索引存储上限的90%" >> ../logs/esnormal.out 2>&1
	fi
fi
