# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils eutils git-r3

EGIT_REPO_URI="https://github.com/irungentoo/ProjectTox-Core"

DESCRIPTION="example client for Tox IM network"
HOMEPAGE="http://tox.im"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="nacl test"


RDEPEND="
		sys-libs/ncurses
		net-libs/tox[nacl=]
"
DEPEND="${RDEPEND}"
AUTOTOOLS_AUTORECONF="yes"

src_configure() {
	local myeconfargs=(
		$(use_enable test testing)
		$(use_enable nacl)
		--enable-ntox
		--disable-daemon
	)
	autotools-utils_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/build/.libs/nTox
}

pkg_postinst() {
	use nacl && (
		ewarn "Although NaCl-linked tox is faster in crypto-things, NaCl-build is"
		ewarn "not portable (you'll be unable to ship binary packages to another machine)."
	)
}
