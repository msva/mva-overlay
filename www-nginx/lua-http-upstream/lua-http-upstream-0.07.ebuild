# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_lua_upstream_module.so")

GITHUB_A="openresty"
GITHUB_PN="lua-upstream-nginx-module"
GITHUB_PV="v${PV}"

inherit nginx-module

DESCRIPTION="Nginx module to expose Lua API for Nginx upstreams"
HOMEPAGE="https://openresty.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE="luajit"

DEPEND="
	${CDEPEND}
	www-servers/nginx:mainline[luajit=]
	www-nginx/lua-http[luajit=]
	|| (
		virtual/lua[luajit=]
		!luajit? (
			|| (
				( virtual/lua dev-lang/lua:5.1 )
				<dev-lang/lua-5.2:0
			)
		)
		luajit? (
			|| (
				virtual/lua[luajit]
				>=dev-lang/luajit-2
			)
		)
	)
"
RDEPEND="
	${DEPEND}
"

DOCS=( "${NG_MOD_WD}"/README.md )

nginx-module-configure() {
	if use luajit; then
		export LUAJIT_LIB=$($(tc-getPKG_CONFIG) --variable libdir luajit)
		export LUAJIT_INC=$($(tc-getPKG_CONFIG) --variable includedir luajit)
	else
		export LUA_LIB=$($(tc-getPKG_CONFIG) --variable libdir lua)
		export LUA_INC=$($(tc-getPKG_CONFIG) --variable includedir lua)
	fi

	append-cflags "-I/usr/include/nginx/lua-http"
}

nginx-module-postinst() {
	ewarn "This module assumes that lua-http module would be loaded before it."
	ewarn "Use 'include modules.d/<modname>.conf;' directives in the right order."
}
