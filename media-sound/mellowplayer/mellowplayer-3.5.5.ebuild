# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MIN_VERSION="3.10"

inherit cmake flag-o-matic toolchain-funcs xdg-utils

MY_PN="MellowPlayer"

DESCRIPTION="Cloud music integration for your desktop"
HOMEPAGE="https://colinduquesnoy.gitlab.io/MellowPlayer"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/colinduquesnoy/${MY_PN}.git"
else
	KEYWORDS="-* ~amd64"
	MY_P="${MY_PN}-${PV}"
	SRC_URI="https://gitlab.com/colinduquesnoy/${MY_PN}/-/archive/${PV}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+widevine"

DEPEND="
	>=dev-qt/qtquickcontrols2-5.9:5
	>=dev-qt/qtquickcontrols-5.9:5[widgets]
	>=dev-qt/qtwebengine-5.9:5[-bindist,widgets]
	>=dev-qt/qttranslations-5.9:5
	>=dev-qt/qtgraphicaleffects-5.9:5
	dev-libs/libevent
	media-libs/mesa
"

RDEPEND="
	${DEPEND}
	widevine? ( www-plugins/chrome-binary-plugins:* )
	x11-libs/libnotify
"
# www-plugins/adobe-flash:*

src_prepare(){
	use widevine && PATCHES=( "${FILESDIR}/widevine-path.patch" )
	cmake-utils_src_prepare
}

src_configure(){
	if test-flags-CXX -std=c++17;then
		if tc-is-gcc; then
			[ $(gcc-major-version) -lt 6 ] && die "You need at least GCC 6.0 in order to build ${MY_PN}"
		fi
		if tc-is-clang; then
			[ $(clang-major-version) -lt 3.5 ] && die "You need at least Clang 3.5 in order to build ${MY_PN}"
		fi
	else
		die "You need a c++17 compatible compiler in order to build ${MY_PN}"
	fi
	cmake-utils_src_configure
}

pkg_postinst(){
	xdg_desktop_database_update
}

pkg_postrm(){
	xdg_desktop_database_update
}
