#!/sbin/runscript

depend() {
    need net
}

RUN_AS=teamcity

checkconfig() {
    return 0
}

start() {
    checkconfig || return 1

    ebegin "Starting ${SVCNAME}"

    . /etc/conf.d/teamcity
    su $RUN_AS -c "cd /opt/teamcity/bin/ && /bin/bash runAll.sh start &> /dev/null"
    eend $?
}

stop() {
    ebegin "Stopping ${SVCNAME}"

    . /etc/conf.d/teamcity
    su $RUN_AS -c "cd /opt/teamcity/bin/ && /bin/bash runAll.sh stop &> /dev/null"
    eend $?
}
