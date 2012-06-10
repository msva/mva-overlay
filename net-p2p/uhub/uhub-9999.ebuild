# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; Bumped by mva; $

EAPI="4"

inherit eutils

if [ "$PV" != "9999" ]; then
	SRC_URI="http://www.extatic.org/downloads/uhub/${P}-src.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	inherit git-2
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/janvidar/uhub.git https://github.com/janvidar/uhub.git"
	KEYWORDS=""
fi

DESCRIPTION="High performance peer-to-peer hub for the ADC network"
HOMEPAGE="https://uhub.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug +ssl"

DEPEND="
	=dev-lang/perl-5*
	ssl? ( >=dev-libs/openssl-0.9.8 )
"
RDEPEND="${DEPEND}"

UHUB_USER="${UHUB_USER:-uhub}"
UHUB_GROUP="${UHUB_GROUP:-uhub}"

src_compile() {
	opts="RELEASE=YES"
#	export CFLAGS="${CFLAGS}"
#	export LDFLAGS="${LDFLAGS}"

	use debug && opts="RELEASE=NO FUNCTRACE=YES"
	use ssl || opts="USE_SSL=NO $opts"
	emake $opts SILENT=YES || die "Failed to build"
}

src_install() {
	dodir /usr/bin
	dodir /etc/uhub
	emake DESTDIR="${D}" UHUB_PREFIX="${D}/usr" install || die "Failed to install"
	doman doc/*1
	dodoc doc/*txt
	insinto /etc/uhub
	doins doc/users.conf
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
}

pkg_postinst() {
	enewgroup "${UHUB_GROUP}"
	enewuser "${UHUB_USER}" -1 -1 "/var/lib/run/${PN}" "${UHUB_GROUP}"
}
