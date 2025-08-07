#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

echo "$(date) 开始清理" >> /home/iwipitbackup/cleanfile_debug.log

backup_dir='/home/iwipitbackup'

find $backup_dir -type f \( -name "*.dmp" -o -name "*.log" -o -name "*.tar.gz" \) -mtime +14 -exec echo "准备删除：{}" >> /home/iwipitbackup/cleanfile_debug.log \; -exec rm -f {} \;

echo "$(date) 删除完成！" >> /home/iwipitbackup/cleanfile_debug.log

