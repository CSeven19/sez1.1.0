# 1 docker安装，运行
rootdir=$(pwd)
echo "----------安装开始----------"
docker_install(){
        cd ${rootdir}/docker/package
        rpm -Uvh *.rpm --nodeps --force && cd ../ && rpm -Uvh container-selinux-2.9-4.el7.noarch.rpm --nodeps --force && rpm -Uvh docker-ce-18.03.1.ce-1.el7.centos.x86_64.rpm --nodeps --force
	if [ $? -ne 0 ];then
		echo "docker 安装失败"
	fi
	cd ${rootdir}
}
docker_run(){
        systemctl start docker
}

# 2 docker net网络转bridge网络
nat2bridge(){
        rpm -ivh ${rootdir}/docker/net-tools-2.0-0.6.20130109git.fc19.x86_64.rpm --nodeps --force && rpm -ivh ${rootdir}/docker/bridge-utils-1.5-9.el7.x86_64.rpm --nodeps --force
        if [ $? == 0 ];then
                pkill docker
                iptables -t nat -F
                ifconfig docker0 down
                brctl delbr docker0
                systemctl restart docker
        else
                echo "docker nat网络转桥接网络失败"
        fi
}

docker_main(){
	docker info
	if [ $? == 0 ];then
		echo "docker已安装并启动"
	else
		docker_run
		if [ $? == 0 ];then
			echo "docker已安装并启动完毕"
		else
			echo "docker开始安装"
		        docker_install
       			if [ $? == 0 ];then
                		echo "docker安装完毕"
                		echo "docker启动开始"
                		docker_run
                		if [ $? == 0 ];then
                        		echo "docker启动成功"
					nat2bridge
                		else
                        		echo "docker启动失败"
                		fi
        		else
                		echo "docker安装失败，请查看日志调整"
        		fi
		fi
	fi
}
docker_main &&

# 3 加载java镜像
java8_load(){
        if [ -z "$(docker images java8:v1 | grep java8)" ];then
                docker load -i ${rootdir}/docker/java8.tar
                echo "java8镜像加载成功"
        fi
}
java8_load &&


# 4 springbootadmin镜像加载
sba_install(){
        # 读取sba.config修改jar包中yml文件配置
        eurekazone=$(cat ${rootdir}/config/sba.config | grep eureka.client.serviceUrl.defaultZone)
        temparray=(${eurekazone//=/ })
        mzone=${temparray[1]}
        echo "eureka设置:"${mzone}
        if [ -z "$(docker images | grep sbaserver)" ];then
                cd ${rootdir}/SBA
                #jar xf spring-boot-admin-server-1.0.0.jar BOOT-INF/classes/application.yml
                old=EUREKA_CLIENT_DEFAULTZONE
                rm -f BOOT-INF/classes/application.yml &&
                cp BOOT-INF/classes/application_template.yml BOOT-INF/classes/application.yml &&
                sed -i "s|${old}|${mzone}|g"  BOOT-INF/classes/application.yml &&
                jar uf spring-boot-admin-server-1.0.0.jar BOOT-INF/classes/application.yml &&
                docker build -t sbaserver:v1 .
        else
                echo "sbaserver已加载镜像"
        fi
	cd ${rootdir}
}
sba_install &&

# 5 elk镜像安装
es_install(){
        if [ -z "$(docker images elasticsearch:6.6.1 | grep elasticsearch)" ];then
                docker load -i ${rootdir}/ELK/es.tar 2>/dev/null
        fi
}
kibana_install(){
        if [ -z "$(docker images kibana:6.6.1 | grep kibana)" ];then
                docker load -i ${rootdir}/ELK/kibana.tar 2>/dev/null
        fi
}
logstash_install(){
        if [ -z "$(docker images logstash:6.6.1 | grep logstash)" ];then
               docker load -i ${rootdir}/ELK/logstash.tar 2>/dev/null
        fi
        # rpm方式比较方便，暂时不适用docker安装logstash
        #rpm -ivh ./ELK/logstash-6.6.1.rpm --nodeps --force &&
        #if [ -z "$(ls /usr/share/logstash/bin | grep logstash-elk.conf)" ];then
        #        cp ./config/logstash-elk.conf /usr/share/logstash/bin
        #else
        #        rm -f /usr/share/logstash/bin/logstash-elk.conf && cp ./config/logstash-elk.conf /usr/share/logstash/bin
        #fi
}
es_install && kibana_install && logstash_install &&

# 6 zabbix镜像安装
cd ./Zabbix
zabbix_mysql(){
        if [ -z "$(docker images mysql:5.7 | grep mysql)" ];then
                docker load -i ${rootdir}/Zabbix/mysql5.7.tar 2>/dev/null
        fi
}
zabbix_gate(){
        if [ -z "$(docker images zabbix/zabbix-java-gateway:latest | grep zabbix/zabbix-java-gateway)" ];then
                docker load -i ${rootdir}/Zabbix/gateway.tar 2>/dev/null
        fi
}
zabbix_server(){
        if [ -z "$(docker images zabbix/zabbix-server-mysql:latest | grep zabbix/zabbix-server-mysql)" ];then
                docker load -i ${rootdir}/Zabbix/zabbix-server.tar 2>/dev/null
        fi
}
zabbix_client(){
        if [ -z "$(docker images zabbix/zabbix-web-nginx-mysql:latest | grep zabbix/zabbix-web-nginx-mysql)" ];then
                docker load -i ${rootdir}/Zabbix/zabbix-clent.tar 2>/dev/null
        fi
}
zabbix_mysql && zabbix_gate && zabbix_server && zabbix_client
echo "----------安装结束----------"
