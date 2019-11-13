#!/bin/ksh
#Written by Arun

export dt=`date +"%Y%m%d"`
export ORACLE_HOME=`cat /s1/scms/app/scms/tsky_path/oracle_home_path.txt`
export sql_user_name=scms_batch
export sql_user_pwd=sKieBatch
export REPORT_PATH=/s1/scms/app/scms/scripts/DAS_sheet
##########Getting Yesterday's date in desired Format#####################
#export YESTERDAY=$((dt-1))
YESTERDAY=$(TZ=$(date +%Y%m%d)+24; date '+%Y%m%d')
export sql_service=`cat /s1/scms/app/scms/tsky_path/db_name.txt`
export SQLPLUS=$ORACLE_HOME/bin/sqlplus


echo $YESTERDAY

cd /logs/scms_log
touch scms_164.txt
echo /log/scms-logs-164 > scms_164.txt
echo `ls -lrt |wc -l` >> scms_164.txt
echo `du -sh` >> scms_164.txt
#truncate -s-2 scms_164.txt
mv scms_164.txt /s1/scms/app/scms/util/data/.

cd /s1/scms/app/scms/util/data
echo CA-Connection-TimeOut-164 >> scms_164.txt
grep -w 5300  scms_errors_$YESTERDAY.xls |wc -l  >> scms_164.txt
mv scms_164.txt /s1/scms/app/scms/scripts/DAS_sheet/.

cd /s1/scms/app/scms/scripts/DAS_sheet
#####################BMAIL & BOXDUN BMAIL##############################
export sql_user_name=scmsread
export sql_user_pwd=tsscms
export sql_service=pscms
export SQLPLUS=$ORACLE_HOME/bin/sqlplus


BMAIL=$($SQLPLUS -S $sql_user_name/$sql_user_pwd@$sql_service <<EOF
set pagesize 0 feedback off verify off heading off echo off;
SELECT COUNT(1) FROM scms_master.commands_history WHERE action_code='SDFRFM' AND opr='KENAN' AND exec_date> TO_DATE(TO_CHAR(SYSDATE-(1/24),'YYYYMMDDHH24MISS'),'YYYYMMDD
HH24MISS') AND exec_date < TO_DATE(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),'YYYYMMDDHH24MISS');
EOF)

BOXDUN=$($SQLPLUS -S $sql_user_name/$sql_user_pwd@$sql_service <<EOF
set pagesize 0 feedback off verify off heading off echo off;
SELECT COUNT(1) FROM scms_master.commands_history WHERE action_code='BOXDUN' AND opr='SCMS' AND exec_date> TO_DATE(TO_CHAR(SYSDATE-(1/24),'YYYYMMDDHH24MISS'),'YYYYMMDDH
H24MISS') AND exec_date < TO_DATE(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),'YYYYMMDDHH24MISS');
EOF)

echo SCMS_BMAIL >> scms_164.txt
echo $BMAIL >> scms_164.txt
echo BOX_DUN_BMAIL >> scms_164.txt
echo $BOXDUN >> scms_164.txt

cd /s1/scms/app/scms/scripts/DAS_sheet

sftp kenanmonitor@10.1.18.58 <<-!
cd /s1/kenan/arbor/custom_utilities/DAS_sheet
mput scms_164.txt
bye
!

unalias rm
rm *.txt
