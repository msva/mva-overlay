# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit multilib eutils git-2

DESCRIPTION="Lua WSAPI Library"
HOMEPAGE="https://github.com/keplerproject/wsapi"
SRC_URI=""

EGIT_REPO_URI="git://github.com/msva/wsapi.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"
# xavante"

RDEPEND=">=dev-lang/lua-5.1
	luajit? ( dev-lang/luajit:2 )
	dev-libs/fcgi
	virtual/httpd-fastcgi"
#	xavante? ( dev-lua/xavante )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	LUA="lua";
	use luajit && LUA="luajit"
	cd "${S}"
	./configure "${LUA}"
}

src_compile() {
	use luajit && INC="-I/usr/include/luajit-2.0/"
	emake DESTDIR="${D}" CC="$(tc-getCC) -fPIC -DPIC" LDFLAGS="${LDFLAGS}" INC="${INC}" CFLAGS="${CFLAGS}" || die "Can't copmile Lua-FCGI library"
}

src_install() {
	emake DESTDIR="${D}" install
	emake DESTDIR="${D}" install-fcgi
}