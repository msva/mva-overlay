# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="stevedonovan"

inherit lua

DESCRIPTION="Libraries for input handling, functional programming and OS path management."
HOMEPAGE="https://github.com/stevedonovan/Penlight"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples test luajit"

# TODO: Lua 5.2 handling

DEPEND="
	${RDEPEND}
	doc? ( dev-lua/ldoc )
"

#HTML_DOCS=(html/.)
DOCS=(README.md CONTRIBUTING.md)
EXAMPLES=(examples/.)

all_lua_compile() {
	use doc && (
		pushd doc &>/dev/null
		ldoc . -d ../html
		popd
	)
}

each_lua_test() {
	${LUA} run.lua tests
}

each_lua_install() {
	dolua lua/pl
}
