# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Libraries for input handling, functional programming and OS path management."
HOMEPAGE="https://github.com/lunarmodules/Penlight"
EGIT_REPO_URI="https://github.com/lunarmodules/Penlight"

LICENSE="MIT"
SLOT="0"
IUSE="doc examples test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${LUA_DEPS}
	dev-lua/luafilesystem[${LUA_USEDEP}]
"
BDEPEND="
	doc? ( dev-lua/ldoc[${LUA_USEDEP}] )
"
DEPEND="${RDEPEND}"

src_compile() {
	if use doc; then
		ldoc . -d docs || eerror "Failed (non-fatal) to build HTML documentation"
		mv docs html
	fi
}

each_lua_test() {
	${ELUA} run.lua tests
}

src_test() {
	lua_foreach_impl each_lua_test
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lua/pl
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	if use doc; then
		DOCS+=(html)
	fi
	einstalldocs
}
