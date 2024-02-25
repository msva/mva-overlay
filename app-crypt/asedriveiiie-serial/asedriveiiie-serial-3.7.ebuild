# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ASEDriveIIIe Serial Card Reader"
HOMEPAGE="https://www.athena-scs.com/"
SRC_URI="https://web.archive.org/web/20180601000000/http://www.athena-scs.com/downloads/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND=">=sys-apps/pcsc-lite-1.3.0"
BDEPEND="virtual/pkgconfig"

DOCS=( ChangeLog README )

src_install() {
	default

	insinto /etc/reader.conf.d
	newins "etc/reader.conf" "${PN}.conf"

	einstalldocs
}

pkg_postinst() {
	local conf="/etc/reader.conf.d/${PN}.conf"
	elog "NOTICE:"
	elog "1. Update ${conf} file"
	elog "2. Run\n  \$ update-reader.conf \# yes this is a command..."
	elog "3. Restart pcscd"
}

pkg_postrm() {
	#
	# Without this, pcscd will not start next time.
	#
	local conf="/etc/reader.conf.d/${PN}.conf"
	if ! [ -f "$(grep LIBPATH "${conf}" | sed 's/LIBPATH *//' | sed 's/ *$//g' | head -n 1)" ]; then
		rm "${conf}"
		update-reader.conf
		elog "NOTICE:"
		elog "You need to restart pcscd"
	fi
}
