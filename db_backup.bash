#! /bin/bash

#Nathan was here
#v2

#Backup Directories
DAILY=~/bu/day
WEEKLY=~/bu/week
MONTHLY=~/bu/month

if [ ! $# -eq 2 ] ; then
        echo "Usage: $0 <DB USER> <DB NAME>"
        exit 1
else
        DB_USER=$1
        DB_NAME=$2
fi

#Create directories if they don't exist
for D in $DAILY $MONTHLY $WEEKLY ; do
        if [ ! -d $D ] ; then
                mkdir -p $D
        fi
done

#today's backup
BU_NAME="$DAILY/$DB_NAME-$(date -u +%u).sql.gz"
pg_dump -U $DB_USER $DB_NAME | gzip > $BU_NAME

#if it's monday, copy it out to the WEEKLY (keeps 4 weeks worth)
if [ $(date -u +%u) -eq 1 ] ; then
        WEEK_NO=$(expr $(date -u +%W) % 4 + 1)
        cp $BU_NAME $WEEKLY/$DB_NAME-$WEEK_NO.sql.gz

        #if it's the first week of a cycle, keep it as a monthly too
        if [ $WEEK_NO -eq 1 ] ; then
                cp $BU_NAME $MONTHLY/$DB_NAME-$(date -u +%m).sql.gz
        fi
fi
