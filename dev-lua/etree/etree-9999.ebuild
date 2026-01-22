# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Library for XML documents manipulations as simple Lua data structures"
HOMEPAGE="https://github.com/msva/etree"
EGIT_REPO_URI="https://github.com/msva/etree"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-lua/luaexpat[${LUA_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

HTML_DOCS=(doc/manual.html doc/style.css)

src_compile() { :; }

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins src/${PN}.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	DOCS+=(doc/manual.txt)
	einstalldocs
}
