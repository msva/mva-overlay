# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd

MY_P=${P/_p/.r}
DESCRIPTION="An IP-Transparent Tor Hidden Service Connector"
HOMEPAGE="https://www.onioncat.org/"
SRC_URI="https://www.cypherpunk.at/ocat/download/Source/current/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +http log +queue relay +rtt i2p"

RDEPEND="
	net-vpn/tor
	i2p? (
		|| (
			net-vpn/i2pd
			net-vpn/i2p
		)
	)
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i \
		-e '/CFLAGS=/s#-O2##g' \
		-e '/CFLAGS=/s#-g##g' \
		configure || die

	default
}

src_configure() {
	myeconfargs=(
		$(use_enable debug)
		$(use_enable log packet-log)
		$(use_enable http handle-http)
		$(use_enable queue packet-queue)
		$(use_enable !relay check-ipsrc)
		$(use_enable rtt)
	)

	econf ${myeconfargs[@]}
}

src_install() {
	default

	use i2p || rm "${ED}/usr/bin/gcat"

	use i2p && (
		newinitd "${FILESDIR}"/garlicat.initd garlicat
		newconfd "${FILESDIR}"/garlicat.confd garlicat

		systemd_dounit "${FILESDIR}"/garlicat.service
	)
	newinitd "${FILESDIR}"/onioncat.initd onioncat
	newconfd "${FILESDIR}"/onioncat.confd onioncat
	systemd_dounit "${FILESDIR}"/onioncat.service

	insinto /var/lib/tor
	doins glob_id.txt hosts.onioncat
}

pkg_postinst() {
	einfo "See https://www.onioncat.org/configuration/"
	einfo "for configuration guide."
}
