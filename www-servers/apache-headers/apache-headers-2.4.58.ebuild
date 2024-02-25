# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# latest gentoo apache files
GENTOO_PATCHSTAMP="20231019"
GENTOO_DEVELOPER="graaff"
GENTOO_PATCHNAME="gentoo-apache-2.4.58"

DESCRIPTION="Header files from the Apache Web Server"
HOMEPAGE="https://httpd.apache.org/"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x64-macos ~x64-solaris"

SRC_URI="
	mirror://apache/httpd/httpd-${PV}.tar.bz2
	https://dev.gentoo.org/~${GENTOO_DEVELOPER}/dist/apache/${GENTOO_PATCHNAME}-${GENTOO_PATCHSTAMP}.tar.bz2
"

GENTOO_PATCHDIR="${WORKDIR}/${GENTOO_PATCHNAME}"
S="${WORKDIR}/httpd-${PV}"

PATCHES="${GENTOO_PATCHDIR}/patches/*.patch"

src_compile() { :; }

src_install() {
	insinto /usr/include/apache2
	doins include/*.h
	doins os/unix/*.h
	doins server/mpm/prefork/*.h
	doins server/mpm/event/*.h
	doins modules/*/*.h
}
