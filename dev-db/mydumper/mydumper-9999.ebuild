# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake git-r3

DESCRIPTION="A high-performance multi-threaded backup toolset for MySQL and Drizzle"
HOMEPAGE="https://github.com/maxbube/mydumper"
EGIT_REPO_URI="https://github.com/maxbube/${PN}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	dev-db/mysql-connector-c:=
	dev-libs/libpcre:=
	dev-libs/openssl:0=
	dev-libs/glib:=
	sys-libs/zlib:=
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
"

PATCHES=("${FILESDIR}/${PN}-atomic.patch")

src_prepare() {
	# respect user cflags; do not expand ${CMAKE_C_FLAGS} (!)
	sed -i -e 's:-Werror -O3 -g:${CMAKE_C_FLAGS}:' CMakeLists.txt || die

	# fix doc install path
	sed -i -e "s:share/doc/mydumper:share/doc/${PF}:" docs/CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=("-DBUILD_DOCS=$(usex doc)")

	cmake-utils_src_configure
}
