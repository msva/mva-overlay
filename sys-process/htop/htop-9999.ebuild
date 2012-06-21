# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/htop/htop-1.0.1.ebuild,v 1.10 2012/05/18 02:32:29 ryao Exp $

EAPI=4

inherit subversion

DESCRIPTION="interactive process viewer"
HOMEPAGE="http://htop.sourceforge.net"
SRC_URI=""
ESVN_REPO_URI="https://htop.svn.sourceforge.net/svnroot/htop/trunk"
ESVN_BOOTSTRAP="./autogen.sh"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="elibc_FreeBSD kernel_linux openvz unicode vserver"

RDEPEND="sys-libs/ncurses[unicode?]"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README )

pkg_setup() {
	if use elibc_FreeBSD && ! [[ -f ${ROOT}/proc/stat && -f ${ROOT}/proc/meminfo ]]; then
		eerror
		eerror "htop needs /proc mounted to compile and work, to mount it type"
		eerror "mount -t linprocfs none /proc"
		eerror "or uncomment the example in /etc/fstab"
		eerror
		die "htop needs /proc mounted"
	fi

	if ! has_version sys-process/lsof; then
		ewarn "To use lsof features in htop(what processes are accessing"
		ewarn "what files), you must have sys-process/lsof installed."
	fi
}

src_unpack() {
	subversion_fetch || die "${ESVN}: unknown problem occurred in subversion_fetch."
	subversion_bootstrap || die "${ESVN}: unknown problem occurred in subversion_bootstrap."
}

src_prepare() {
	sed -i -e '1c\#!'"${EPREFIX}"'/usr/bin/python' \
		scripts/MakeHeader.py || die
}

src_configure() {
	[[ $CBUILD != $CHOST ]] && export ac_cv_file__proc_{meminfo,stat}=yes #328971

	econf \
		$(use_enable openvz) \
		$(use_enable kernel_linux cgroup) \
		$(use_enable vserver) \
		$(use_enable unicode) \
		--enable-taskstats
}
