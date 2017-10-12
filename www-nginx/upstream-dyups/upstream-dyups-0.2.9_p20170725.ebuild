# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_dyups_module.so")

GITHUB_A="yzprofile"
GITHUB_PN="ngx_http_dyups_module"
GITHUB_SHA="a5e75737e04ff3e5040a80f5f739171e96c3359c"

inherit nginx-module

DESCRIPTION="Module for updating upstreams config by restful interface"
HOMEPAGE="https://github.com/yzprofile/ngx_http_dyups_module"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE="lua luajit"

DEPEND="
	${CDEPEND}
	lua? (
		|| (
			virtual/lua
			<dev-lang/lua-5.2:0
			dev-lang/lua:5.1
			dev-lang/luajit:2
		)
		luajit? (
			|| (
				virtual/lua[luajit]
				dev-lang/luajit:2
			)
		)
	)
"
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/README.md )

REQUIRED_USE="luajit? ( lua )"

nginx-module-prepare() {
	if use lua; then
		local lua="lua"
		if use luajit; then
			lua="luajit"
		fi
		sed -r \
			-e '1iHTTP_LUA_SRCS=lua.c' \
			-e "1ingx_http_lua_module_LIBS=$($(tc-getPKG_CONFIG) --libs ${lua})" \
			-i "config" || die "Can't patch for Lua"
		append-cflags "-I$($(tc-getPKG_CONFIG) --variable includedir ${lua})"
		append-ldflags "-L$($(tc-getPKG_CONFIG) --variable libdir ${lua})"
		NG_MOD_DEPS+=("lua-http")
		NG_MOD_DEFS+=("NGX_DYUPS_LUA")
	fi
}

nginx-module-install() {
	ng_dohdr ngx_http_dyups.h
}
