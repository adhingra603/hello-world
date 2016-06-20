#!/bin/bash

# To Run:
#
# 1. Edit values for Script and Log
# 2. nohup sh runSparchScript.sh &
# 3. Validate output file is getting written to successfully


SPARK_HOME=/mnt/resource/spark/spark-1.4.1-bin-hadoop2.6/
SPARK_BIN=$SPARK_HOME/bin
SPARK_LIB=$SPARK_HOME/lib
CONNECTOR_ASSEMBLY=$SPARK_LIB/spark-cassandra-connector-assembly-1.4.1-SNAPSHOT.jar

# Script to run
SCRIPT=/home/saas/customer-key-migration/table-counts.scala

# Log location
LOGFILE=/home/saas/customer-key-migration/logs/table-counts.out

cd $SPARK_BIN
#$SPARK_BIN/spark-shell --jars $SPARK_LIB/spark-cassandra-connector-assembly-1.4.1-SNAPSHOT.jar

$SPARK_BIN/spark-shell --jars $CONNECTOR_ASSEMBLY < $SCRIPT > $LOGFILE 2>&1
