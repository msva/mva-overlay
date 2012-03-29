# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools eutils git-2

DESCRIPTION="Lua cURL Library"
HOMEPAGE="http://ittner.github.com/lua-iconv"
SRC_URI=""

EGIT_REPO_URI="git://github.com/ittner/lua-iconv.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch_user
	sed -e "s/install -D -s/install -D/" -i Makefile
	sed -e "/make test/d" -i Makefile
}

src_compile() {
	use amd64 && CFLAGS="${CFLAGS} -fPIC"
	emake CFLAGS="${CFLAGS}" LFLAGS="${LDFLAGS} -shared" || die "Can't compile"
}

src_install() {
	emake DESTDIR="${D}" INSTALL_PATH="$(pkg-config lua --variable INSTALL_CMOD)" install || die "Can't install"
}