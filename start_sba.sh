# 1 docker启动
rootdir=$(pwd)
if [ -z "$(docker info)" ];then
	systemctl start docker
fi

# 2 因config修改需要重新构建jar包，所以重新构建sba镜像
sba_install(){
        # 读取sba.config修改jar包中yml文件配置
	docker rmi -f sbaserver:v1 2>/dev/null
        eurekazone=$(cat ${rootdir}/config/sba.config | grep eureka.client.serviceUrl.defaultZone)
        temparray=(${eurekazone//=/ })
        mzone=${temparray[1]}
        echo "eureka设置:"${mzone}
        cd ${rootdir}/SBA
        #jar xf spring-boot-admin-server-1.0.0.jar BOOT-INF/classes/application.yml
        old=EUREKA_CLIENT_DEFAULTZONE
        rm -f BOOT-INF/classes/application.yml &&
        cp BOOT-INF/classes/application_template.yml BOOT-INF/classes/application.yml &&
        sed -i "s|${old}|${mzone}|g"  BOOT-INF/classes/application.yml &&
        jar uf spring-boot-admin-server-1.0.0.jar BOOT-INF/classes/application.yml &&
        docker build -t sbaserver:v1 .
        cd ${rootdir}
}

# 3 启动sba
sba_run(){
if [ -z "$(docker ps -a | grep sbaserver)" ];then
        docker run --name sbaserver -p 8766:8766 -d sbaserver:v1
else
        docker rm -f sbaserver && docker run --name sbaserver -p 8766:8766 -d sbaserver:v1
fi
if [ $? == 0 ];then
        echo "sbaserver启动成功，请于8766端口访问服务"
else
        echo "sbaserver启动失败"
fi
}
sba_install && sba_run
