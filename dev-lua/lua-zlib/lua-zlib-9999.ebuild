# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils git-2

DESCRIPTION="Lua bindings to zlib"
HOMEPAGE="http://github.com/brimworks/lua-zlib"
EGIT_REPO_URI="git://github.com/brimworks/lua-zlib.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )
		sys-libs/zlib"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

src_prepare() {
	mv *-${PN}-* "${S}"
}

src_configure() {
	MYCMAKEARGS="-DINSTALL_CMOD='$(pkg-config --variable INSTALL_CMOD lua)'"
	cmake-utils_src_configure
}
