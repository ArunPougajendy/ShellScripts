#!/bin/ksh
#Created By Arun

cd /logs/appdir/log
touch tuxedo_58.txt
echo `/logs/appdir/log-TUXEDO` >> tuxedo_58.txt
echo `ls -lrt |wc -l` >> tuxedo_58.txt
echo `du -sh` >> tuxedo_58.txt
mv tuxedo_58.txt /s1/kenan/arbor/custom_utilities/DAS_sheet

cd /s1/kenan/arbor/custom_utilities/DAS_sheet
echo `TUX_PORT:` >> tuxedo_58.txt
echo `netstat -an | grep 2067 | grep "ESTAB" |wc -l` >> tuxedo_58.txt

cd /s1/kenan/arbor/custom_utilities/DAS_sheet

awk '{print $1}' tuxedo_58.txt>> s.txt
cat s.txt| xargs | sed -e 's/ /,/g'>> w.txt
IPSCMS1=`cat w.txt|cut -d, -f1`
IPSCMS1COUNT=`cat w.txt|cut -d, -f2`
IPSCMS1SIZE=`cat w.txt|cut -d, -f3`
IPSCMS1TUX=`cat w.txt|cut -d, -f4`
IPSCMS1TUXCOUNT=`cat w.txt|cut -d, -f5`


############## Connection to Database #################################################
export ORACLE_HOME =`cat /s1/kenan/arbor/tsky_path/oracle_home_path.txt|head -1|tail -1`
USER=$userName
PASS=$pasword
DS=$DB

cd $ORACLE_HOME/bin

sqlplus -s $userName/$pasword@$DB << THEEND1
set heading off
set echo off
set feedback off
set showmode off
set verify off
set termout off
set pagesize 0
set linesize 100

INSERT INTO MIGRATION.DAS_SHEET(LOG_DETAILS,INSERT_DATE,COUNT,USED_SPACE) VALUES('$IPSCMS1',SYSDATE,'$IPSCMS1COUNT','$IPSCMS1SIZE');
INSERT INTO MIGRATION.DAS_SHEET(LOG_DETAILS,INSERT_DATE,COUNT) VALUES('$IPSCMS1TUX',SYSDATE,'$IPSCMS1TUXCOUNT');


COMMIT;

quit

THEEND1

cd /s1/kenan/arbor/custom_utilities/DAS_sheet
unalias rm
rm *.txt