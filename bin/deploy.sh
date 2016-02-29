#!/bin/sh
set -e
PRO_DIR="/tmp/blogweb"
PRO_SSH="git@github.com:rocky-luo/blogweb.git"
JETTY_BASE_SUF="-jettybase"
JETTY_BASE=$PRO_DIR$JETTY_BASE_SUF
if [ ! -d $PRO_DIR ]; then
    TMP_CUR_PWD=`pwd`
    echo "mkdir -p $PRO_DIR"
    mkdir -p $PRO_DIR
    cd $PRO_DIR
    echo "git clone $PRO_SSH"
    git clone $PRO_SSH
    cd $TMP_CUR_PWD
fi

TMP_CUR_PWD=`pwd`
cd $PRO_DIR
git checkout master
git pull
cd $TMP_CUR_PWD


if [ ! -d $JETTY_BASE ]; then
    echo "mkdir -p $JETTY_BASE/webapps"
    mkdir -p $JETTY_BASE/webapps
    java -jar $JETTY_HOME/start.jar --add-to-startd=http,deploy,jsp
fi
mvn clean -U -Dmaven.test.skip=true package
cp webapps/*.war $JETTY_BASE/webapps/ROOT.war
java -jar $JETTY_HOME/start.jar

