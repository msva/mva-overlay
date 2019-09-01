# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils git-r3

DESCRIPTION="A high-performance multi-threaded backup toolset for MySQL and Drizzle"
HOMEPAGE="https://github.com/maxbube/mydumper"
EGIT_REPO_URI="https://github.com/maxbube/${PN}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	dev-libs/libpcre
	virtual/mysql
	dev-libs/glib:2
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	doc? ( <dev-python/sphinx-1.3 )
"

DOCS=( README )

src_prepare() {
	# respect user cflags; do not expand ${CMAKE_C_FLAGS} (!)
	sed -i -e 's:-Werror -O3 -g:${CMAKE_C_FLAGS}:' CMakeLists.txt
	# fix doc install path
	sed -i -e "s:share/doc/mydumper:share/doc/${PF}:" docs/CMakeLists.txt

	default
}

src_configure() {
	mycmakeargs=( -DBUILD_DOCS="$(usex doc)" )

	cmake-utils_src_configure
}
