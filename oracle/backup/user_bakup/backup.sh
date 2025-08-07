#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

export ORACLE_HOME=/home/oracle/app/oracle/product/11.2.0.4
export PATH=$ORACLE_HOME/bin:$PATH

export NLS_LANG=AMERICAN_AMERICA.AL32UTF8
export LANG=en_US.UTF-8

# 获取当前日期和时间，格式为 yyyyMMdd_HHmmss
current_date=$(date +%Y%m%d_%H%M%S)

# 设置备份目录（确保此目录已经创建并且Oracle用户有权限）
backup_dir='/home/iwipitbackupzytk'

# 设置数据库连接字符串
db_user='zytk40/159357@//localhost:1521/zytk40'

# 设置生成的备份文件名
dumpfile="zytk40_database_backup_${current_date}.dmp"
logfile="zytk40_database_backup_${current_date}.log"

# 执行expdp备份命令
echo "开始执行expdp备份..."
# expdp $db_user directory=IWIPITBACKUP dumpfile=$dumpfile logfile=$logfile full=y

expdp $db_user directory=IWIPITBACKUPZYTK dumpfile=$dumpfile logfile=$logfile schemas=ZYTK40


# 单表测试
# expdp $db_user tables=AC_ACCCATEGORY directory=IWIPITBACKUP dumpfile=$dumpfile logfile=$logfile


# 等待压缩完成后再进行文件传输
wait

filename=zytk40_database_backup_${current_date}.tar.gz

# 压缩备份文件和日志文件为 tar 包
echo "开始压缩备份文件..."
tarfile="${backup_dir}/zytk40_database_backup_${current_date}.tar.gz"
# 普通压缩
# tar -czf $tarfile -C $backup_dir $dumpfile $logfile
# 快速压缩
tar -cf - -C "$backup_dir" "$dumpfile" "$logfile" | pv -s 17G | pigz -p 16 > "$tarfile"

# 等待压缩完成后再进行文件传输
wait


remote_user='root'
remote_server='192.168.93.13'
remote_dir='/home/oracle/iwiporaclebackupzytk40'

# 使用scp传送tar包到远程服务器
echo "开始传输备份文件到远程服务器..."


# 重试机制
RETRY_TIMES=10
SLEEP_SECONDS=10

for ((i=1; i<=RETRY_TIMES; i++)); do
    echo "第 $i 次尝试传输文件..."
    # scp -o ConnectTimeout=10 -o ServerAliveInterval=5 -o ServerAliveCountMax=3 "$SRC_FILE" "${DEST_USER}@${DEST_HOST}:${DEST_PATH}"
    scp -o ConnectTimeout=10 -o ServerAliveInterval=5 -o ServerAliveCountMax=3 $tarfile $remote_user@$remote_server:$remote_dir/$filename
    if [ $? -eq 0 ]; then
        echo "传输成功。"
        break
    else
        echo "传输失败，等待 $SLEEP_SECONDS 秒后重试..."
        sleep $SLEEP_SECONDS
    fi
done


# scp $tarfile $remote_user@$remote_server:$remote_dir/$filename
# pv $tarfile | ssh $remote_user@$remote_server "cat > $remote_dir/full_database_backup_${current_date}.tar.gz"

wait

# 如果传送成功，可以删除本地的tar包（可选）
rm -f $tarfile


echo "备份并传输完成！"
