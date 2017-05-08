# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools linux-info eutils systemd git-r3

DESCRIPTION="Linux kernel (3.13+) firewall, NAT and packet mangling tools"
HOMEPAGE="http://netfilter.org/projects/nftables/"
SRC_URI=""
EGIT_REPO_URI="git://git.netfilter.org/nftables/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug gmp +readline"

RDEPEND=">=net-libs/libmnl-1.0.3
	>net-libs/libnftnl-1.0.5
	gmp? ( dev-libs/gmp:0= )
	readline? ( sys-libs/readline:0= )"
DEPEND="${RDEPEND}
	>=app-text/docbook2X-0.8.8-r4
	sys-devel/bison
	sys-devel/flex"

pkg_setup() {
	if kernel_is ge 3 13; then
		CONFIG_CHECK="~NF_TABLES"
		linux-info_pkg_setup
	else
		eerror "This package requires kernel version 3.13 or newer to work properly."
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--sbindir="${EPREFIX}"/sbin \
		$(use_enable debug) \
		$(use_with readline cli) \
		$(use_with !gmp mini_gmp)
}

src_install() {
	default

	dodir /usr/libexec/${PN}
	cp -p "${FILESDIR}"/libexec/${PN}.sh "${D}"/usr/libexec/${PN}/${PN}.sh

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.init ${PN}
	keepdir /var/lib/nftables

	systemd_dounit "${FILESDIR}"/systemd/${PN}-restore.service
}
