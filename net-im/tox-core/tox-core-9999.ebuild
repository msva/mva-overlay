# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://github.com/irungentoo/ProjectTox-Core"

inherit git-2 cmake-utils

DESCRIPTION="Free as in freedom Skype replacement"
HOMEPAGE="http://tox.im"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="nacl"

RDEPEND="dev-libs/libconfig
	net-libs/libsodium
	nacl? ( net-libs/nacl )"
DEPEND="${RDEPEND}
	dev-python/sphinx"

src_prepare() {
	# remove -Werror from CFLAGS
	sed -i 's/ -Werror//' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use nacl)
		)
	cmake-utils_src_configure
}

src_install() {
	default
	cd "${BUILD_DIR}" || die
	local binaries=(
		DHT_test
		Lossless_UDP_testclient
		Lossless_UDP_testserver
		Messenger_test
		nTox
		toxic/toxic
	)
	dobin ${binaries[@]/#/testing/}
}

pkg_postinst() {
	elog "DHT node list is available via https://gist.github.com/Proplex/6124860"
	elog "or in #tox @ irc.freenode.org"
}
