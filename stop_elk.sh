docker rm -f kibana 2>/dev/null
docker rm -f es 2>/dev/null
docker rm -f logstash 2>/dev/null
#logstash=$(jps | grep Logstash)
#temparray=(${logstash// / })
#if [ -z "${logstash}" ];then
#        echo "未发现该logstash程序"
#else
#        echo "关闭进程号为:"${temparray[0]}"的logstash程序"
#        kill -9 ${temparray[0]} && echo "logstash关闭成功"
#fi
