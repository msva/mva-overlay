# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A basic XML serializer for Lua"
HOMEPAGE="https://github.com/bibby/lua-xml-ser"
EGIT_REPO_URI="https://github.com/bibby/lua-xml-ser"

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-lua/slaxml[${LUA_USEDEP}]
"
DEPEND="${RDEPEND}"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins {list,xml-ser{,de}}.lua # too bad it expropriates such a common module name like "list" in "global" namespace
}
src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		mkdir -p examples
		mv test-xml-ser{,de}.lua examples
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
