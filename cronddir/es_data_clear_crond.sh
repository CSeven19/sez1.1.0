deleteLog(){
        shijian=`date +%Y.%m.%d -d "$1 days ago"`
        echo $shijian
        curl -XDELETE "0.0.0.0:9200/logstash-${shijian}"
}
deleteLog $1
