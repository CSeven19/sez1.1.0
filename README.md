sez1.1.0
=======

[![NuGet](https://img.shields.io/nuget/v/LitJson.svg)](https://www.nuget.org/packages/LitJson) [![MyGet](https://img.shields.io/myget/litjson/vpre/LitJson.svg?label=myget)](https://www.myget.org/gallery/litjson)

use springboot admin & elastic kibana & zabbix to monitor you Micro services


# Files
config 	# 配置文件夹
docker	# docker部署文件夹
ELK	# Elasticsearch+Logstash+Kibana部署文件夹
eureka	# SBA测试用注册服务，不用安装
logs	# 监控日志文件夹
SBA	# Springboot Admin部署文件夹i
cronddir # 定时任务脚本
Zabbix	# Zabbix部署文件夹
ReadMe.txt      # 程序说明
install_all.sh	# 安装sba+elk+zabbix整套程序
install_customized.sh	# 可选择安装sha,elk,zabbix任意一套及几套服务
start_all.sh	# 启动所有服务
start_sba.sh	# 启动sba服务
start_elk.sh	# 启动elk服务
start_zabbix	# 启动zabbix服务
stop_all.sh	# 关闭所有服务
stop_elk.sh	# 关闭elk
stop_sba.sh	# 关闭sba
stop_zabbix.sh	# 关闭zabbix
restart_all.sh	# 重启所有服务
portrelease.sh	# 端口开放脚本
es_data_clear.sh	# elasticsearch数据定时清理脚本
es_index_listener.sh	# es索引监控脚本


# License

[Unlicense][unlicense] (public domain).

[mygetgallery]: [https://www.myget.org/gallery/litjson]
[litjson]: [unlicense](http://unlicense.org/
[nunit]: http://www.nunit.org/
[pkg-config]: http://www.freedesktop.org/wiki/Software/pkg-config
[unlicense]: http://unlicense.org/