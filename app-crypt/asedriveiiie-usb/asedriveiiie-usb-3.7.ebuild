# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ASEDriveIIIe USB Card Reader"
HOMEPAGE="https://www.athena-scs.com/"
SRC_URI="https://web.archive.org/web/20180601000000/http://www.athena-scs.com/downloads/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND=">=sys-apps/pcsc-lite-1.3.0
	=virtual/libusb-0*"
BDEPEND="virtual/pkgconfig"

DOCS=( ChangeLog README )

#src_install() {
#	default
#	einstalldocs
#}

pkg_postinst() {
	elog "NOTICE:"
	elog "You should restart pcscd."
}
