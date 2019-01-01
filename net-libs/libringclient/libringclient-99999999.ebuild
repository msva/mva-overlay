# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3 cmake-utils
EGIT_REPO_URI="https://github.com/Elv13/ring-lrc"
EGIT_BRANCH="work5"
KEYWORDS=""

DESCRIPTION="libringclient is the common interface for Ring applications"
HOMEPAGE="https://tuleap.ring.cx/projects/ring"

LICENSE="GPL-3"

SLOT="0"

IUSE="doc +dbus +video static-libs"

DEPEND="
	~net-voip/ring-daemon-${PV}[dbus?,video]
	dev-qt/qtdbus:5=
"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_VIDEO="$(usex video true false)"
		-DENABLE_STATIC="$(usex static-libs true false)"
		-DENABLE_LIBWRAP="$(usex !dbus true false)"
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_BUILD_TYPE=Release
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	use !doc && rm README.md
	cmake-utils_src_install
}
