# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; Bumped by mva; $

EAPI="5"

inherit cmake-utils eutils

if [ "$PV" != "9999" ]; then
	SRC_URI="http://www.extatic.org/downloads/uhub/${P}-src.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	inherit git-2
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/janvidar/uhub.git"
	KEYWORDS=""
fi

DESCRIPTION="High performance peer-to-peer hub for the ADC network"
HOMEPAGE="https://uhub.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug +ssl systemd"

DEPEND="
	>=dev-util/cmake-2.8.3
	ssl? ( >=dev-libs/openssl-0.9.8 )
"
#	=dev-lang/perl-5*
RDEPEND="${DEPEND}"

UHUB_USER="${UHUB_USER:-uhub}"
UHUB_GROUP="${UHUB_GROUP:-uhub}"

src_configure() {
	mycmakeargs=(
		$(_use_me_now_inverted "" debug RELEASE)
		$(cmake-utils_use_use ssl)
		$(cmake-utils_use_use systemd)
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
