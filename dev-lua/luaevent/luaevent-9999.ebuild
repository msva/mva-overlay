# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit toolchain-funcs git-2

DESCRIPTION="libevent bindings for Lua"
HOMEPAGE="http://luaforge.net/projects/luaevent http://repo.or.cz/w/luaevent.git"
EGIT_REPO_URI="git://github.com/harningt/luaevent.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )
	>=dev-libs/libevent-1.4"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	sed -i "s:^CFLAGS =:CFLAGS +=:" "${S}/Makefile" \
		|| die "sed failed"
	sed -i "s:^LDFLAGS =:LDFLAGS +=:" "${S}/Makefile" \
		|| die "sed failed"
	sed -i "/^LDFLAGS/a CC = $(tc-getCC)" "${S}/Makefile" \
		|| die "sed failed"
	sed -i "s:^LUA_INC_DIR ?=.*:LUA_INC_DIR ?= $(pkg-config --variable INSTALL_INC lua):" "${S}/Makefile" \
		|| die "sed failed"
	sed -i "s:^INSTALL_DIR_LUA ?=.*:INSTALL_DIR_LUA ?= $(pkg-config --variable INSTALL_LMOD lua):" "${S}/Makefile" \
		|| die "sed failed"
	sed -i "s:^INSTALL_DIR_BIN ?=.*:INSTALL_DIR_BIN ?= $(pkg-config --variable INSTALL_CMOD lua):" "${S}/Makefile" \
		|| die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
