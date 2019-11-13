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
touch scms_163.txt
echo /log/scms-logs-163 > scms_163.txt
echo `ls -lrt |wc -l` >> scms_163.txt
echo `du -sh` >> scms_163.txt
#truncate -s-2 scms_163.txt
mv scms_163.txt /s1/scms/app/scms/util/data/.

cd /s1/scms/app/scms/util/data
echo CA-Connection-TimeOut-163 >> scms_163.txt
grep -w 5300  scms_errors_$YESTERDAY.xls |wc -l  >> scms_163.txt
mv scms_163.txt /s1/scms/app/scms/scripts/DAS_sheet/.

cd /s1/scms/app/scms/scripts/DAS_sheet

sftp kenanmonitor@10.1.18.58 <<-!
cd /s1/kenan/arbor/custom_utilities/DAS_sheet
mput scms_163.txt
bye
!

unalias rm
rm *.txt
