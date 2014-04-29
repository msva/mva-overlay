# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/libguestfs-appliance/libguestfs-appliance-1.20.0.ebuild,v 1.1 2013/03/25 12:06:45 maksbotan Exp $

EAPI=5

CHECKREQS_DISK_USR=5G
CHECKREQS_DISK_BUILD=5G

inherit check-reqs

DESCRIPTION="VM applance disk image used in libguestfs package"
HOMEPAGE="http://libguestfs.org/"
SRC_URI="http://libguestfs.org/download/binaries/appliance/appliance-${PV}.tar.xz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/guestfs/
	doins -r appliance/

	newenvd "${FILESDIR}"/env.file 99"${PN}"
}

pkg_postinst() {
	elog "Please run:"
	elog " env-update && source /etc/profile"
}
