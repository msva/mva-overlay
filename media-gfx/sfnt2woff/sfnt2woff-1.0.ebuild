# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake patches

DESCRIPTION="Very small utility to convert font files to WOFF"
HOMEPAGE="http://people.mozilla.com/~jkew/woff/"
SRC_URI="https://github.com/ppicazo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="( GPL-2 BSD LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

src_prepare() {
	mv "CmakeLists.txt" "CMakeLists.txt"
	sed -r \
		-e '/set\(CMAKE_EXE_LINKER_FLAGS/d' \
		-e '/install/iTARGET_LINK_LIBRARIES(sfnt2woff z)\nTARGET_LINK_LIBRARIES(woff2sfnt z)\n' \
		-i CMakeLists.txt
	patches_src_prepare
}
