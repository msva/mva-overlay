# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua mercurial

DESCRIPTION="Lua feeds parsing library"
HOMEPAGE="https://code.matthewwild.co.uk/lua-feeds"
EHG_REPO_URI="https://code.matthewwild.co.uk/lua-feeds"

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="dev-lua/squish"

each_lua_compile() {
	squish
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	newins feeds{.min,}.lua
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		mkdir -p examples
		mv demo.lua demo_string.lua examples
		DOCS=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
