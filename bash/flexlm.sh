#!/bin/bash
#
# flexlm This starts and stops flexlm
#
# description: Start or stop the flexlm license manager + vendor daemons
#
# Return values according to LSB for all commands:
# 0 - success
# 1 - generic or unspecified error
# 2 - invalid or excess argument(s)
# 3 - unimplemented feature (e.g. "reload")
# 4 - insufficient privilege
# 5 - program is not installed
# 6 - program is not configured
# 7 - program is not running
#
#
PATH=/sbin:/bin:/usr/bin:/usr/sbin
LICENSE_FILE=/opt/Linux_Licensing_Daemon/flexlm/License.dat
LMGRD_HOME=/opt/Linux_Licensing_Daemon
LMGRD_LOGFILE=/var/log/lmgrd.log
prog="flexlm"
# Source function library.
. /lib/lsb/init-functions
# Check license file
test -f $LICENSE_FILE || exit 6
RETVAL=0
start () {
    test -x $LMGRD_HOME/lmgrd || exit 5
    echo -n $"Starting Microsemi $prog: "
    su -c "$LMGRD_HOME/lmgrd -c $LICENSE_FILE -log $LMGRD_LOGFILE" -
#    caeadmin
    RETVAL=$?
    return $RETVAL
}
stop(){
    echo -n $"Stopping Microsemi $prog: "
    su -c "$LMGRD_HOME/lmutil lmdown -c $LICENSE_FILE -q" - caeadmin
    RETVAL=$?
    return $RETVAL
}
status(){
    su -c "$LMGRD_HOME/lmutil lmstat -c $LICENSE_FILE" - caeadmin
    RETVAL=$?
    return $RETVAL
}
reload(){
    stop
    start
}
restart(){
    stop
    start
}
case "$1" in
    start)
	start
	;;
    stop)
	stop
	;;
    status)
	status
	;;
    restart)
	restart
	;;
    reload|force-reload)
	reload
	;;
    *)
	echo $"Usage $0 {start|stop|status|restart|reload|force-reload}"
	RETVAL=3
esac
exit $RETVAL
