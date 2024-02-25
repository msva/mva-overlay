# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="An IP-Transparent Tor Hidden Service Connector"
HOMEPAGE="https://github.com/rahra/onioncat/"

if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rahra/onioncat"
else
	SRC_URI="https://github.com/rahra/onioncat/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="debug +http log +queue +rtt i2p"

RDEPEND="
	net-vpn/tor
	i2p? (
		|| (
			net-vpn/i2pd
			net-vpn/i2p
		)
	)
"

S="${WORKDIR}/${PN}-${C_SHA}"

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
		$(use_enable rtt)
	)

	econf ${myeconfargs[@]}
}

src_install() {
	default

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
