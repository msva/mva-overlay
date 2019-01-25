# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LUA_COMPAT="luajit2"
VCS="git"
GITHUB_A="openresty"
GITHUB_PN="lua-${PN}"

inherit lua

DESCRIPTION="New LuaJIT FFI based API for lua-nginx-module"
HOMEPAGE="https://github.com/openresty/lua-resty-core"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	virtual/lua[luajit]
	www-servers/nginx:*[nginx_modules_http_lua]
	dev-lua/resty-lrucache
"
DEPEND="
	${RDEPEND}
"

DOCS=(README.markdown)

each_lua_install() {
	dolua_jit lib/resty
}
