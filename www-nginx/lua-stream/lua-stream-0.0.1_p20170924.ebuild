# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

NG_MOD_LIST=("ngx_stream_lua_module.so")

GITHUB_A="openresty"
GITHUB_PN="stream-lua-nginx-module"
#GITHUB_PV="v${PV}"
GITHUB_SHA="fde198fa5fe5befad70bf3403822ef1364a795a8"

inherit nginx-module

DESCRIPTION="Embed the Power of Lua into NGINX (stream)"
HOMEPAGE="https://openresty.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE="luajit"

DEPEND="
	${CDEPEND}
	www-servers/nginx:mainline[ssl,stream,ssl-cert-cb,luajit=]
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
RDEPEND="${DEPEND}"

DOCS=( "${NG_MOD_WD}"/{valgrind.suppress,README.md} )

nginx-module-prepare() {
	if use luajit; then
		sed -r \
			-e "s|-lluajit-5.1|$($(tc-getPKG_CONFIG) --libs luajit)|g" \
			-i "config" || die "Can't patch for LuaJIT"
	fi
}

nginx-module-configure() {
	if use luajit; then
		export LUAJIT_LIB=$($(tc-getPKG_CONFIG) --variable libdir luajit)
		export LUAJIT_INC=$($(tc-getPKG_CONFIG) --variable includedir luajit)
	else
		export LUA_LIB=$($(tc-getPKG_CONFIG) --variable libdir lua)
		export LUA_INC=$($(tc-getPKG_CONFIG) --variable includedir lua)
	fi

	myconf+=("--with-stream=dynamic")
	myconf+=("--with-stream_ssl_module")
}
