#!/bin/env sh
#
# 磁盘容量监控部署脚本

set -euo pipefail

###################################
# 此函数功能部署与卸载磁盘监控脚本
# 需要设置的变量:
#	DEPLOY
#	HOSTNAME
#	IP
#	TAG
#	WEBHOOK
#	CRITICAL
###################################
function deploy() {
	DEPLOY=${deploy:-'install'}
	# 设置机器人webhook
	WEBHOOK=${webhook:-''}
	# 当前主机名
	HOSTNAME=${hostname:-"`hostname`"}
	# 当前主机IP
	IP=${ip:-"`hostname -I | awk '{print $1}'`"}
	# 设置此主机标记
	TAG=${tag:-''}
	# 报警阈值
	CRITICAL=${critical:-'90'}

	case "$DEPLOY" in
		install)
			[ -z "$WEBHOOK" ] && echo "请输入 WEBHOOK 后重试" && exit 1
			[ -z "$TAG" ] && echo "请输入 TAG 后重试" && exit 1
			[ -d /opt/monitor/bin ] || mkdir -p /opt/monitor/bin && cd /opt/monitor/bin
			# 调用生成监控脚本 monitor 函数
			monitor
			sed -i /monitor\/bin/d /var/spool/cron/root
			echo "0 9-22 * * * /bin/bash /opt/monitor/bin/disk.sh > /dev/null 2>&1" >> /var/spool/cron/root
			;;
		uninstall)
			sed -i /monitor\/bin/d /var/spool/cron/root
			rm -rf /opt/monitor
			;;
		esac
}

###################################
# 此函数生成硬盘容量监控脚本
# 调用的变量:
#	HOSTNAME
#	IP
#	TAG
#	WEBHOOK
###################################
function monitor(){
	cat > disk.sh << END
#!/bin/env sh
#
# 磁盘容量健康检查并报警

# 获取当前硬盘列表与容量
partition_list=(\`df -h | grep -E -v 'tmpfs | \
docker|containerd' | \
awk 'NF>3&&NR>1{sub(/%/,"",\$(NF-1));print \$NF,\$(NF-1)}'\`)

date=\`date "+%F %T"\`

for ((i=0; i<\${#partition_list[@]};i+=2 ))
do
	if [ "\${partition_list[((i+1))]}" -lt "$CRITICAL" ];then
		echo "OK! \${partition_list[i]} used \${partition_list[((i+1))]}%"
	else
		if [ "\${partition_list[((i+1))]}" -gt "$CRITICAL" ];then
			crit_info="\$date \n 警告!!! \n 主机名: $HOSTNAME \n 主机IP: $IP \n 服务器标签: $TAG \n 目录:\${partition_list[i]} \n 已使用硬盘空间: \${partition_list[((i+1))]}%"
			curl -X POST -H "Content-Type: application/json" \
			-d '{"msg_type":"text","content":{"text":"'"\$crit_info"'"}}' \
			$WEBHOOK
		fi
	fi
done
END
}

# 调用部署函数
deploy
