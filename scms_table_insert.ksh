#!/bin/ksh
#Created By Arun

cd /s1/kenan/arbor/custom_utilities/DAS_sheet

awk '{print $1}' scms_163.txt>> s.txt
cat s.txt| xargs | sed -e 's/ /,/g'>> w.txt
awk '{print $1}' scms_164.txt>> p.txt
cat p.txt| xargs | sed -e 's/ /,/g'>> t.txt
SCMS1=10.1.152.163
SCMS2=10.1.152.164
IPSCMS1=`cat w.txt|cut -d, -f1`
IPSCMS1COUNT=`cat w.txt|cut -d, -f2`
IPSCMS1SIZE=`cat w.txt|cut -d, -f3`
IPSCMS1CA=`cat w.txt|cut -d, -f4`
IPSCMS1CACOUNT=`cat w.txt|cut -d, -f5`

IPSCMS2=`cat t.txt|cut -d, -f1`
IPSCMS2COUNT=`cat t.txt|cut -d, -f2`
IPSCMS2SIZE=`cat t.txt|cut -d, -f3`
IPSCMS2CA=`cat t.txt|cut -d, -f4`
IPSCMS2CACOUNT=`cat t.txt|cut -d, -f5`

############## Connection to Database #################################################
export ORACLE_HOME =`cat /s1/kenan/arbor/tsky_path/oracle_home_path.txt|head -1|tail -1`
USER=migration
PASS=migration
DS=pbpcu02

cd $ORACLE_HOME/bin

sqlplus -s migration/migration@pbpcu02 << THEEND1
set heading off
set echo off
set feedback off
set showmode off
set verify off
set termout off
set pagesize 0
set linesize 100

INSERT INTO MIGRATION.DAS_SHEET(LOG_DETAILS,INSERT_DATE,COUNT,USED_SPACE) VALUES('$IPSCMS1',SYSDATE,'$IPSCMS1COUNT','$IPSCMS1SIZE');
INSERT INTO MIGRATION.DAS_SHEET(LOG_DETAILS,INSERT_DATE,COUNT,USED_SPACE) VALUES('$IPSCMS2',SYSDATE,'$IPSCMS2COUNT','$IPSCMS2SIZE');

INSERT INTO MIGRATION.DAS_SHEET(LOG_DETAILS,INSERT_DATE,COUNT) VALUES('$IPSCMS1CA',SYSDATE,'$IPSCMS1CACOUNT');
INSERT INTO MIGRATION.DAS_SHEET(LOG_DETAILS,INSERT_DATE,COUNT) VALUES('$IPSCMS2CA',SYSDATE,'$IPSCMS2CACOUNT');


COMMIT;

quit

THEEND1

cd /s1/kenan/arbor/custom_utilities/DAS_sheet
unalias rm
rm *.txt