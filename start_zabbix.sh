# 1 docker启动
if [ -z "$(docker info)" ];then
        systemctl start docker
fi

# 2 zabbix启动
# zabbix容器启动
zabbix_mysql_run(){
       # if [ ! -d "/data/mysql" ];then
       #         mkdir -p /data/mysql
       # fi
       # if [ ! -d "/data/mysql/conf" ];then
       #         mkdir /data/mysql/conf
       # fi
if [ -z "$(docker ps -a | grep mysql-server)" ];then
        docker run --name mysql-server -t \
			-v /data/mysql:/var/lib/mysql \
                        -e MYSQL_database="zabbix" \
                        -e MYSQL_USER="zabbix" \
                        -e MYSQL_PASSWORD="zabbix_pwd" \
                        -e MYSQL_ROOT_PASSWORD="root_pwd" \
                        -d mysql:5.7
else
        docker rm -f mysql-server &&
        docker run --name mysql-server -t \
			-v /data/mysql:/var/lib/mysql \
                        -e MYSQL_database="zabbix" \
                        -e MYSQL_USER="zabbix" \
                        -e MYSQL_PASSWORD="zabbix_pwd" \
                        -e MYSQL_ROOT_PASSWORD="root_pwd" \
                        -d mysql:5.7
fi
}
zabbix_gate_run(){
if [ -z "$(docker ps -a | grep zabbix-java-gateway)" ];then
        docker run --name zabbix-java-gateway -t \
                        -p 10052:10052 \
                        -d zabbix/zabbix-java-gateway:latest
else
        docker rm -f zabbix-java-gateway &&
        docker run --name zabbix-java-gateway -t \
                        -p 10052:10052 \
                        -d zabbix/zabbix-java-gateway:latest
fi
}
zabbix_server_run(){
if [ -z "$(docker ps -a | grep zabbix-server-mysql)" ];then
        docker run --name zabbix-server-mysql -t \
                        -e DB_SERVER_HOST="mysql-server" \
                        -e MYSQL_DATABASE="zabbix" \
                        -e MYSQL_USER="zabbix" \
                        -e MYSQL_PASSWORD="zabbix_pwd" \
                        -e MYSQL_ROOT_PASSWORD="root_pwd" \
                        --link mysql-server:mysql \
                        --link zabbix-java-gateway:zabbix-java-gateway \
                        -p 10051:10051 \
                        -d zabbix/zabbix-server-mysql:latest
else
        docker rm -f zabbix-server-mysql &&
        docker run --name zabbix-server-mysql -t \
                        -e DB_SERVER_HOST="mysql-server" \
                        -e MYSQL_DATABASE="zabbix" \
                        -e MYSQL_USER="zabbix" \
                        -e MYSQL_PASSWORD="zabbix_pwd" \
                        -e MYSQL_ROOT_PASSWORD="root_pwd" \
                        --link mysql-server:mysql \
                        --link zabbix-java-gateway:zabbix-java-gateway \
                        -p 10051:10051 \
                        -d zabbix/zabbix-server-mysql:latest
fi
}
zabbix_client_run(){
if [ -z "$(docker ps -a | grep zabbix-web-nginx-mysql)" ];then
        docker run --name zabbix-web-nginx-mysql -t \
                        -e DB_SERVER_HOST="mysql-server" \
                        -e MYSQL_DATABASE="zabbix" \
                        -e MYSQL_USER="zabbix" \
                        -e MYSQL_PASSWORD="zabbix_pwd" \
                        -e MYSQL_ROOT_PASSWORD="root_pwd" \
                        --link mysql-server:mysql \
                        --link zabbix-server-mysql:zabbix-server \
                        -p 8000:8080 \
                        -d zabbix/zabbix-web-nginx-mysql:latest
else
        docker rm -f zabbix-web-nginx-mysql &&
        docker run --name zabbix-web-nginx-mysql -t \
                        -e DB_SERVER_HOST="mysql-server" \
                        -e MYSQL_DATABASE="zabbix" \
                        -e MYSQL_USER="zabbix" \
                        -e MYSQL_PASSWORD="zabbix_pwd" \
                        -e MYSQL_ROOT_PASSWORD="root_pwd" \
                        --link mysql-server:mysql \
                        --link zabbix-server-mysql:zabbix-server \
                        -p 8000:8080 \
                        -d zabbix/zabbix-web-nginx-mysql:latest
fi
}
zabbix_mysql_run && zabbix_gate_run && zabbix_server_run && zabbix_client_run &&
if [ $? == 0 ];then
	echo "zabbix启动成功"
	echo "请于8000端口访问客户端服务，开始zabbix"
else
	echo "zabbix启动失败，请参考zabbix相关docker日志"
fi
