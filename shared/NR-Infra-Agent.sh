#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME="NR-Infra-Agent"
QPKG_ROOT=`/sbin/getcfg $QPKG_NAME Install_Path -f ${CONF}`
APACHE_ROOT=`/sbin/getcfg SHARE_DEF defWeb -d Qweb -f /etc/config/def_share.info`
export QNAP_QPKG=$QPKG_NAME

PID_FILE=$QPKG_ROOT/var/run/nr-infra-agent.pid
AGENT_CONF=$QPKG_ROOT/NewRelicInfraAgent.conf

PLUGIN_DIR=$QPKG_ROOT/etc/newrelic-infra/integrations.d/
AGENT_DIR=$QPKG_ROOT/var/db/newrelic-infra/
LOG_FILE=$QPKG_ROOT/var/log/newrelic-infra/newrelic-infra.log
LICENSE_KEY=NO_LICENSE_KEY_SET
NEWRELIC_SETTINGS_FILE=/etc/newrelic-infra.yml

case "$1" in
  start)
    ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
      if [ "$ENABLED" != "TRUE" ]; then
          echo "$QPKG_NAME is disabled."
          exit 1
      fi

      if test -f "$PID_FILE"; then
          echo "Agent already running under pid $PID"
          exit
      fi


      if test ! -f "$AGENT_CONF"; then
        echo "pid_file: $PID_FILE" > $AGENT_CONF
        echo "plugin_dir: $PLUGIN_DIR" >> $AGENT_CONF
        echo "agent_dir: $AGENT_DIR" >> $AGENT_CONF
        echo "log_file: $LOG_FILE" >> $AGENT_CONF
        echo "license_key: $LICENSE_KEY" >> $AGENT_CONF
      fi

      touch $LOG_FILE
      chmod g+rw $AGENT_CONF

      $QPKG_ROOT/usr/bin/newrelic-infra -config $AGENT_CONF > /dev/null 2>&1 &
    ;;

  stop)
      if test -f "$PID_FILE"; then
        echo "Sending KILL signal to the agent."

        kill `cat $PID_FILE`
        rm $PID_FILE
      fi
    ;;

  restart)
    $0 stop
    $0 start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac

exit 0
