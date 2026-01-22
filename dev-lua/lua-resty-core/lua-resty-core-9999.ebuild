# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( luajit )

inherit lua

DESCRIPTION="New LuaJIT FFI based API for lua-nginx-module"
HOMEPAGE="https://github.com/openresty/lua-resty-core"

if [[ "${PV}" =~ 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/openresty/lua-resty-core"
else
	SRC_URI="https://github.com/openresty/lua-resty-core/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
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
		>=www-servers/nginx-1.28.0-r10[nginx_modules_http_ssl(-)]
		>=www-servers/nginx-1.28.0-r10[nginx_modules_stream_ssli(-)]
		www-servers/nginx[ssl(-)]
	)
	|| (
		www-servers/nginx:*[nginx_modules_http_lua(-)]
		www-nginx/ngx-lua-module[lua_single_target_luajit]
	)
	dev-lua/lua-resty-lrucache[${LUA_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

DOCS+=(docs/.)

src_prepare() {
	default
	mkdir -p docs
	find . -type f -name '*.md' -exec mv -t docs {} ';'
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/resty lib/ngx
}

src_install() {
	einstalldocs
	lua_foreach_impl each_lua_install
}
