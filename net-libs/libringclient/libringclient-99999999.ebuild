# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake
EGIT_REPO_URI="https://github.com/Elv13/ring-lrc"
EGIT_BRANCH="work5"

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
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	use !doc && rm README.md
	cmake_src_install
}
