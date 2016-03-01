#!/bin/sh
set -e
PRO_NAME="blogweb"
TMP_DIR="/tmp"
PRO_DIR="$TMP_DIR/$PRO_NAME"
PRO_SSH="git@github.com:rocky-luo/blogweb.git"
JETTY_BASE_SUF="-jettybase"
JETTY_BASE_DIR="$TMP_DIR/$PRO_NAME$JETTY_BASE_SUF"
PRE_PID=`lsof -i :8080 |grep java | awk '{print $2}'`
if [  "$PRE_PID"x != ""x ]; then
    echo "stop pre proccess..."
    kill -9 $PRE_PID
fi
if [ ! -d $PRO_DIR ]; then
    TMP_CUR_PWD=`pwd`
    echo "mkdir -p $PRO_DIR"
    mkdir -p $PRO_DIR
    cd $TMP_DIR
    echo "git clone $PRO_SSH"
    git clone $PRO_SSH
    cd $TMP_CUR_PWD
fi

TMP_CUR_PWD=`pwd`
cd $PRO_DIR
git checkout master
git pull
cd $TMP_CUR_PWD


if [ ! -d $JETTY_BASE_DIR ]; then
    echo "mkdir -p $JETTY_BASE_DIR/webapps"
    mkdir -p $JETTY_BASE_DIR/webapps
    cd $JETTY_BASE_DIR
    java -jar $JETTY_HOME/start.jar --add-to-startd=http,deploy,jsp,logging,requestlog
fi
cd $PRO_DIR
mvn clean -U -Dmaven.test.skip=true package
cp target/*.war $JETTY_BASE_DIR/webapps/ROOT.war
cd $JETTY_BASE_DIR
java -jar $JETTY_HOME/start.jar

