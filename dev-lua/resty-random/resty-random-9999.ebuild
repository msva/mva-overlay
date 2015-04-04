# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base eutils toolchain-funcs git-r3

DESCRIPTION="LuaJIT FFI-based Random Library for OpenResty"
HOMEPAGE="https://github.com/bungle/lua-${PN}"
SRC_URI=""

EGIT_REPO_URI="https://github.com/bungle/lua-${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	virtual/lua[luajit]
	www-servers/nginx[nginx_modules_http_lua,ssl]
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( "README.md" )

src_install() {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD luajit)"
	mv lib/resty/random.lua lib/resty/resty_random.lua
	doins -r lib/resty

	base_src_install_docs
}
