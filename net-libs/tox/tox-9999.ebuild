# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-multilib git-r3

EGIT_REPO_URI="https://github.com/irungentoo/ProjectTox-Core"

DESCRIPTION="Free as in freedom Skype replacement"
HOMEPAGE="http://tox.im"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="+av logging nacl static-libs test"

REQUIRED_USE="nacl? ( static-libs )"

RDEPEND="
	nacl? ( net-libs/nacl[${MULTILIB_USEDEP}] )
	!nacl? ( dev-libs/libsodium[${MULTILIB_USEDEP}] )
	av? (
		media-libs/opus[${MULTILIB_USEDEP}]
		media-libs/libvpx[${MULTILIB_USEDEP}]
	)
"
DEPEND="
	${RDEPEND}
	dev-libs/libconfig
	sys-devel/automake
	sys-devel/libtool
"
AUTOTOOLS_AUTORECONF="yes"

src_prepare() {
	# Disabling sample DHT_bootstrap node. Emerge tox-bootstrap-daemon instead
	sed \
	-e "s#.*other/Makefile.inc##" \
	-i build/Makefile.am

	autotools-multilib_src_prepare
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable test testing)
		$(use_enable av)
		$(use_enable nacl)
		$(use_with nacl nacl-headers /usr/include/nacl)
		$(use_with nacl nacl-libs /usr/$(get_libdir)/nacl)
		$(use_enable logging)
		$(use_enable static-libs static)
		--disable-ntox
		--disable-daemon
	)
	autotools-utils_src_configure
}

src_configure() {
	autotools-multilib_src_configure
}

pkg_postinst() {
	use nacl && (
		ewarn "Although NaCl-linked tox is faster in crypto-things, NaCl-build is"
		ewarn "not portable (you'll be unable to ship binary packages to another machine)."
	)
}

