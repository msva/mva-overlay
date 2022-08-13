# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

EGIT_REPO_URI="https://github.com/janvidar/uhub.git"

DESCRIPTION="High performance peer-to-peer hub for the ADC network"
HOMEPAGE="https://uhub.org/"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug gnutls sqlite +ssl systemd tools"

RDEPEND="
	ssl? (
		gnutls? ( net-libs/gnutls:* )
		!gnutls? ( >=dev-libs/openssl-0.9.8:* )
	)
	sqlite? (
		dev-db/sqlite:3
	)
"
DEPEND="${RDEPEND}"
BDEPEND="${BDEPEND}
	acct-user/${PN}
	acct-group/${PN}
"

PATCHES=("${FILESDIR}/patches/${PV}")

src_configure() {
	mycmakeargs=(
		-DRELEASE=$(usex debug 'OFF' 'ON')
		-DSSL_SUPPORT=$(usex ssl 'ON' 'OFF')
		-DUSE_OPENSSL=$(usex gnutls 'OFF' 'ON')
		-DSYSTEMD_SUPPORT=$(usex systemd 'ON' 'OFF')
		-DADC_STRESS=$(usex tools 'ON' 'OFF')
	)
	cmake_src_configure
}

src_install() {
	dodir /etc/uhub
	cmake_src_install
	doman doc/*1
	dodoc doc/*txt
	insinto /etc/uhub
	fperms 0700 "/etc/uhub"
	fowners ${PN}:${PN} "/etc/uhub"
	doins doc/uhub.conf
	doins doc/users.conf
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
}
