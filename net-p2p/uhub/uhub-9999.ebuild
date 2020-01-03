# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils git-r3 user
SRC_URI=""
EGIT_REPO_URI="https://github.com/janvidar/uhub.git"
KEYWORDS=""

DESCRIPTION="High performance peer-to-peer hub for the ADC network"
HOMEPAGE="https://uhub.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug gnutls libressl sqlite +ssl systemd tools"

DEPEND="
	ssl? (
		gnutls? ( net-libs/gnutls:* )
		!gnutls? (
			libressl? ( dev-libs/libressl:* )
			!libressl? ( >=dev-libs/openssl-0.9.8:* )
		)
	)
	sqlite? (
		dev-db/sqlite:3
	)
"
DEPEND="
	>=dev-util/cmake-2.8.3
	${RDEPEND}
"

UHUB_USER="${UHUB_USER:-uhub}"
UHUB_GROUP="${UHUB_GROUP:-uhub}"

PATCHES=("${FILESDIR}/patches/${PV}")

src_configure() {
	mycmakeargs=(
		-DRELEASE=$(usex debug 'OFF' 'ON')
		-DSSL_SUPPORT=$(usex ssl 'ON' 'OFF')
		-DUSE_OPENSSL=$(usex gnutls 'OFF' 'ON')
		-DSYSTEMD_SUPPORT=$(usex systemd 'ON' 'OFF')
		-DADC_STRESS=$(usex tools 'ON' 'OFF')
	)
	cmake-utils_src_configure
}

src_install() {
	dodir /etc/uhub
	cmake-utils_src_install
	doman doc/*1
	dodoc doc/*txt
	insinto /etc/uhub
	fperms 0700 "/etc/uhub"
	fowners ${UHUB_USER}:${UHUB_GROUP} "/etc/uhub"
	doins doc/uhub.conf
	doins doc/users.conf
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
}

pkg_setup() {
	enewgroup "${UHUB_GROUP}"
	enewuser "${UHUB_USER}" -1 -1 "/var/lib/run/${PN}" "${UHUB_GROUP}"
}
