# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

NG_MOD_LIST=("ngx_http_lua_module.so")

GITHUB_A="openresty"
GITHUB_PN="lua-nginx-module"
GITHUB_PV="v${PV/_rc/rc}"
NDK=1

inherit nginx-module

DESCRIPTION="Embed the Power of Lua into NGINX (HTTP)"
HOMEPAGE="https://openresty.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# ~x64-macos ~x86-macos ~amd64-linux ~x86-linux"
IUSE="luajit systemtap"

DEPEND="
	${CDEPEND}
	www-servers/nginx:mainline[nginx_modules_http_rewrite,ssl,ssl-cert-cb]
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

DOCS=( "${NG_MOD_WD}"/README.markdown )

nginx-module-prepare() {
	if use luajit; then
		sed -r \
			-e "s|-lluajit-5.1|$($(tc-getPKG_CONFIG) --libs luajit)|g" \
			-i "config" || die "Can't patch for LuaJIT"
		export LUAJIT_LIB=$($(tc-getPKG_CONFIG) --variable libdir luajit)
		export LUAJIT_INC=$($(tc-getPKG_CONFIG) --variable includedir luajit)
	else
		export LUA_LIB=$($(tc-getPKG_CONFIG) --variable libdir lua)
		export LUA_INC=$($(tc-getPKG_CONFIG) --variable includedir lua)
	fi
}

nginx-module-configure() {
	myconf+=("--with-http_ssl_module")
}

nginx-module-install() {
	use systemtap && (
		insinto /usr/share/systemtap
		doins -r tapset
	)

	ng_dohdr src/api/*
}
