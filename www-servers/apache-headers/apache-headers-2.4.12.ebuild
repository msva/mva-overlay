# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

# latest gentoo apache files
GENTOO_PATCHSTAMP="20140731"
GENTOO_DEVELOPER="polynomial-c"
GENTOO_PATCHNAME="gentoo-apache-2.4.10-r1"

DESCRIPTION="Header files from the Apache Web Server"
HOMEPAGE="http://httpd.apache.org/"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x64-macos ~x86-macos ~m68k-mint ~sparc64-solaris ~x64-solaris"
IUSE=""

SRC_URI="
	mirror://apache/httpd/httpd-${PV}.tar.bz2
	http://dev.gentoo.org/~${GENTOO_DEVELOPER}/dist/apache/${GENTOO_PATCHNAME}-${GENTOO_PATCHSTAMP}.tar.bz2
"

GENTOO_PATCHDIR="${WORKDIR}/${GENTOO_PATCHNAME}"
S="${WORKDIR}/httpd-${PV}"

src_prepare() {
	epatch "${GENTOO_PATCHDIR}"/patches/*.patch
}

src_compile() { :; }

src_install() {
	insinto /usr/include/apache2
	doins include/*.h
	doins os/unix/*.h
#	doins server/mpm/prefork/*.h
	doins server/mpm/event/*.h
	doins modules/*/*.h
}
