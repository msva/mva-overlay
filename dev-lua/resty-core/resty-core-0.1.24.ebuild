# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

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
	KEYWORDS="~amd64 ~arm ~x86"
	# TODO: arm64 and others
fi

LICENSE="BSD"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"

IUSE="+lua_targets_luajit"

RDEPEND="
	${LUA_DEPS}
	www-servers/nginx:*[nginx_modules_http_lua]
	dev-lua/resty-lrucache[${LUA_USEDEP}]
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
