# 1 docker启动
if [ -z "$(docker info)" ];then
        systemctl start docker
fi

# 2 启动elk
es_run(){
        # 设置sysctl.conf
        if [ -z "$(cat /etc/sysctl.conf | grep vm.max_map_count)" ];then
                echo "vm.max_map_count = 262144" >>/etc/sysctl.conf
                sysctl -p
        else
		old=vm.max_map_count
		sed -i "s/${old}.*$/vm.max_map_count = 262144/g" /etc/sysctl.conf
                echo "vm.max_map_count已设置"
        fi
        # 运行
        docker rm -f es 2>/dev/null
        docker run --name es \
                        -p 9200:9200 \
                        -p 9300:9300 \
			-e TAKE_FILE_OWNERSHIP=111 \
			-v /home/es/data:/usr/share/elasticsearch/data \
                        -v $(pwd)/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
                        -d elasticsearch:6.6.1
}
kibana_run(){
        docker rm -f kibana 2>/dev/null
        docker run --name kibana -p 5601:5601 \
                -v $(pwd)/config/kibana.yml:/usr/share/kibana/config/kibana.yml \
                -d kibana:6.6.1
}
logstash_run(){
	# docker保留
        docker rm -f logstash 2>/dev/null
        docker run --name logstash \
                        -v $(pwd)/config/logstash/config/:/usr/share/logstash/config/ \
                        -v $(pwd)/config/logstash/pipeline/:/usr/share/logstash/pipeline/ \
                        -p 5044:5044 \
                        -p 9600:9600 \
                        -p 4560:4560 \
                        -d logstash:6.6.1
        # 先关闭logstash服务
	#logstash=$(jps | grep Logstash)
	#temparray=(${logstash// / })
	#if [ -n "${logstash}" ];then
        #	echo "关闭进程号为:"${temparray[0]}"的logstash程序"
        #	kill -9 ${temparray[0]} && echo "logstash关闭成功"
	#fi
	# 启动服务
	#sh /usr/share/logstash/bin/logstash -f /usr/share/logstash/bin/logstash-elk.conf >>./logs/logstash_app.out 2>&1 
}
es_run && kibana_run && logstash_run &&
if [ $? == 0 ];then
	echo "elk启动成功，请于5601端口访问服务"
	echo "如访问kibana显示'Kibana server is not ready yet'.请稍等2分钟.elasticsearch完全启动稍慢"
else
	echo "elk启动失败，请查看docker相关日志及logs中logstash_app.out日志"
fi
