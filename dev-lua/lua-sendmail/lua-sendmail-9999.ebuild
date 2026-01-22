# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Simple wrapper around luasoket smtp.send"
HOMEPAGE="https://github.com/moteus/lua-sendmail"
EGIT_REPO_URI="https://github.com/moteus/lua-sendmail"

LICENSE="MIT"
SLOT="0"
IUSE="doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-lua/luasocket[${LUA_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

HTML_DOCS=(docs/.)

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lua/sendmail.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
