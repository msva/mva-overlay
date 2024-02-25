# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Utility library for functional programming in Lua"
HOMEPAGE="https://github.com/Yonaba/Moses"
EGIT_REPO_URI="https://github.com/Yonaba/Moses"

if ! [[ "${PV}" == 9999 ]]; then
	EGIT_COMMIT="Moses-${PV}-1"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~m68k ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
	# ~riscv
fi

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-lua/luasocket[${LUA_USEDEP}]
"
DEPEND="
	${RDEPEND}
"

DOCS+=(doc/tutorial.md)
HTML_DOCS=(doc/index.html doc/manual)

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins "${PN}"{,_min}.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
