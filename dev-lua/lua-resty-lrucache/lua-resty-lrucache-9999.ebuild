# Copyright 2026 mva
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit lua

DESCRIPTION="A simple LRU cache for OpenResty and the ngx_lua module (based on LuaJIT FFI)"
HOMEPAGE="https://github.com/openresty/lua-resty-lrucache"

if [[ "${PV}" =~ 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openresty/lua-resty-lrucache"
else
	SRC_URI="https://github.com/openresty/lua-resty-lrucache/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
	# ~ppc64 ~riscv
	# 👆 luajit 🤷
fi

LICENSE="BSD"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"

IUSE="+lua_targets_luajit"

RDEPEND="
	${LUA_DEPS}
	|| (
		www-servers/nginx:*[nginx_modules_http_lua(-)]
		www-nginx/ngx-lua-module[lua_single_target_luajit]
	)
"
DEPEND="
	${RDEPEND}
"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/resty
}

src_compile() { :; }

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
