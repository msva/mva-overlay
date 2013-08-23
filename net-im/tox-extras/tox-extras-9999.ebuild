# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

EGIT_REPO_URI="https://github.com/irungentoo/ProjectTox-Core"

inherit git-2 cmake-utils toolchain-funcs

DESCRIPTION="Free as in freedom Skype replacement"
HOMEPAGE="http://tox.im"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="unicode multilib"
# -nacl (currently, gento nacl package is incompatible with tox shared mode)

RDEPEND="
	net-im/tox-core
	dev-libs/check
	dev-libs/libconfig
	net-libs/libsodium
	sys-libs/ncurses[unicode=]
"

#	sys-libs/ncurses[unicode=]
#	!nacl? ( net-libs/libsodium )
#	nacl? ( net-libs/nacl )

DEPEND="${RDEPEND}"

src_prepare() {
	sed \
		-e "/add_subdirectory(core)/d" \
		-i CMakeLists.txt

}

src_configure() {
#		$(cmake-utils_use_use nacl)
	local mycmakeargs=(
		$(cmake-utils_use !unicode NO_WIDECHAR)
		)
	cmake-utils_src_configure
}

src_install() {
	default
	cd "${BUILD_DIR}" || die
	local binaries=(
		crypto_speed_test
		DHT_test
		Lossless_UDP_testclient
		Lossless_UDP_testserver
		Messenger_test
		nTox
	)
	local other_binaries=(
		DHT_bootstrap
	)
	local tests_binaries=(
		crypto_test
		friends_test
		messenger_test
	)
	dobin ${binaries[@]/#/testing/}
	dobin ${other_binaries[@]/#/other/}
	dobin ${tests_binaries[@]/#/auto_tests/}
}

pkg_postinst() {
	elog "DHT node list is available via https://gist.github.com/Proplex/6124860"
	elog "or in #tox @ irc.freenode.org"
}
