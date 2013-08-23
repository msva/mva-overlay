# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

EGIT_REPO_URI="https://github.com/irungentoo/ProjectTox-Core"

inherit cmake-multilib git-2

DESCRIPTION="Free as in freedom Skype replacement"
HOMEPAGE="http://tox.im"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="doc"
# -nacl (currently, gento nacl package is incompatible with tox shared mode)

RDEPEND="
	net-libs/libsodium[${MULTILIB_USEDEP}]
"
#	!nacl? ( net-libs/libsodium )
#	nacl? ( net-libs/nacl )

DEPEND="
	${RDEPEND}
	doc? ( dev-python/sphinx )
"

src_prepare() {
	sed \
		-e "/add_subdirectory(auto_tests)/d" \
		-e "/add_subdirectory(testing)/d" \
		-e "/add_subdirectory(other)/d" \
		-e "/find_package(Cursesw REQUIRED)/d" \
		-i CMakeLists.txt

	sed -r \
		-e 's:(toxcore toxcore_static DESTINATION) lib:\1 ${CMAKE_INSTALL_LIBDIR}:' \
		-i core/CMakeLists.txt
}

src_configure() {
#		$(cmake-utils_use_use nacl)
	local mycmakeargs=(
		-DSHARED_TOXCORE=ON
		)
	cmake-multilib_src_configure
}

src_compile() {
	cmake-multilib_src_compile
	use doc && cmake-multilib_src_compile docs
}

pkg_postinst() {
	elog "DHT node list is available via https://gist.github.com/Proplex/6124860"
	elog "or in #tox @ irc.freenode.org"
}
