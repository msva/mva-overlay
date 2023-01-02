# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua client for NATS messaging system"
HOMEPAGE="https://github.com/dawnangel/lua-nats"
EGIT_REPO_URI="https://github.com/dawnangel/lua-nats"

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-lua/lua-cjson[${LUA_USEDEP}]
	dev-lua/luasocket[${LUA_USEDEP}]
	dev-lua/uuid[${LUA_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins "src/${PN}.lua"
}

src_compile() { :; }

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
