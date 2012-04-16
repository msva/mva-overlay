#!/bin/bash
echo "THIS SCRIPT DO NOT WORKING YET"
exit 1
#dbkey="sssss";
EBUILD="${1}"
SKEL="../../skel.metadata.xml"
PM_EBUILD_HOOK_DIR=/etc/portage/env
EBUILD_PHASE=depend
PORTDIR=/usr/portage
ECLASSDIR=${PORTDIR}/eclass
source /etc/make.conf
source /etc/init.d/functions.sh
source /usr/lib/portage/bin/ebuild.sh
#source "${EBLD}"
echo ${P}
