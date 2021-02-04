# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib

DESCRIPTION="A Fast, Easy and Free BitTorrent client - command line (CLI) version"
HOMEPAGE="http://www.transmissionbt.com/"
MY_PN="transmission"
MY_P="${MY_PN}-${PV}"
LICENSE="|| ( GPL-2 GPL-3 Transmission-OpenSSL-exception ) GPL-2 MIT"

SRC_URI="http://download.transmissionbt.com/${MY_PN}/files/${MY_P}.tar.xz"

KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE=""

RDEPEND="
	>=dev-libs/libevent-2.0.10:=
	>=net-misc/curl-7.16.3[ssl]
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}
	>=dev-libs/glib-2.32
	dev-util/intltool
	sys-devel/gettext
	virtual/os-headers
	virtual/pkgconfig
"

SLOT=0

S="${WORKDIR}/${MY_P}"

src_configure() {
	econfargs+=(
		--enable-cli
		--disable-daemon
		--without-gtk
		--without-systemd-daemon
	)
	econf "${econfargs[@]}"
}

src_install() {
	dobin cli/transmission-cli
	doman cli/transmission-cli.1
}
