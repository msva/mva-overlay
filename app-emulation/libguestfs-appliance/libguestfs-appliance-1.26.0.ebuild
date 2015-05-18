# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; $

EAPI="5"

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
