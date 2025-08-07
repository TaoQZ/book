## oracle备份

首先要保证两边oracle版本一致



## 备份文件夹

备份数据库和恢复数据库两边都要执行的操作

都要有一个备份文件夹

需要注意的是 无论是备份数据库还是恢复数据库都要把权限赋予 oracle 用户 要不然会导致导入和导出失败

```sql
-- 使用sysdba登录
sqlplus / as sysdba

-- 查看oracle里所有的文件夹
SELECT * FROM all_directories;

-- 需要切换到 oracle用户
su oracle
-- 该文件夹 oracle 需要有权限
CREATE OR REPLACE DIRECTORY ORACLEBACKUP AS  '/home/oraclebackup';

-- 将该备份文件夹赋予 某个用户权限
GRANT READ, WRITE ON DIRECTORY ORACLEBACKUP TO TAO;

GRANT EXP_FULL_DATABASE TO TAO;

SELECT directory_name, directory_path FROM dba_directories WHERE directory_name = 'ORACLEBACKUP';


-- 给予 oracle 用户 备份文件夹的权限
chown -R oracle:oinstall /home/oraclebackup

chmod 750 /home/oraclebackup

```



## 备份和恢复

```shell
# 备份 指定数据库/用户
expdp 'TAO/123456a@//备份服务器IP:1521/ORCL' directory=IWIPBACKUPTAO dumpfile=tao_database_backup.dmp logfile=tao_database_backup.log schemas=TAO

# 恢复 指定数据库/用户
impdp 'system/taoqingzhou@//恢复服务器IP:1521/taoqingzhou' directory=ORACLEBACKIP dumpfile=TAO_DATABASE_BACKUP.DMP logfile=tao_database_restore.log schemas=TAO remap_schema=TAO:TAO

# 将oracle目录添加到环境变量方便使用命令
vim ~/.bash_profile

export ORACLE_HOME=/home/oracle/app/oracle/product/11.2.0
export PATH=$ORACLE_HOME/bin:$PATH
export ORACLE_SID=taoqingzhou

source ~/.bash_profile
```









