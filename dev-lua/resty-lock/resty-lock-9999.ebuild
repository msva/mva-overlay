# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils toolchain-funcs git-r3

DESCRIPTION="Simple shm-based nonblocking lock API"
HOMEPAGE="https://github.com/openresty/lua-${PN}"
SRC_URI=""

EGIT_REPO_URI="https://github.com/openresty/lua-${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-lang/luajit:2
	www-servers/nginx[nginx_modules_http_lua]
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

src_prepare() {
	local lua=luajit;

	sed -r \
		-e "1,6s#(PREFIX).*#\1=/usr#" \
		-e "1,6s#(LUA_LIB_DIR).*#\1=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})#" \
		-e "1,6s#(LUA_INCLUDE_DIR).*#\1=$($(tc-getPKG_CONFIG) --variable includedir ${lua})#" \
		-i Makefile
}
