#!@RCD_SCRIPTS_SHELL@
#
# $NetBSD: cherokee.sh,v 1.4 2003/09/27 02:35:15 xtraeme Exp $
#

# PROVIDE: cherokee
# REQUIRE: DAEMON

. /etc/rc.subr

name="cherokee"
rcvar=$name
command="@PREFIX@/sbin/${name}"
pidfile="/var/run/${name}.pid"
required_files="@PKG_SYSCONFDIR@/$name.conf"

load_rc_config $name
run_rc_command "$1"
