# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
IS_MULTILIB=true
GITHUB_A="luaposix"

inherit autotools lua

DESCRIPTION="POSIX binding, including curses, for Lua 5.1 and 5.2"
HOMEPAGE="https://github.com/luaposix/luaposix"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples ncurses"

RDEPEND="
	virtual/lua[bit32]
	ncurses? ( sys-libs/ncurses:0 )
"

DEPEND="
	${RDEPEND}
	sys-kernel/linux-headers
	virtual/libc
	doc? ( dev-lua/ldoc )
"
#	dev-libs/gnulib
#	dev-lua/specl
#	dev-lua/lyaml

DOCS=(README.md NEWS.md)
EXAMPLES=(doc/examples/.)
HTML_DOCS=(html/.)

all_lua_prepare() {
	mkdir -p html
	sed \
		-e '/^dir/s@"."@"../html"@' \
		-i build-aux/config.ld.in

	cp build-aux/config.ld.in build-aux/config.ld
	cp lib/posix.lua.in lib/posix/init.lua

	sed -r \
		-e "s/@PACKAGE_STRING@/${P}/" \
		-i build-aux/config.ld lib/posix/init.lua

	lua_default
}

all_lua_compile() {
	use doc && (
		pushd build-aux &>/dev/null
		ldoc -d ../doc .
		popd
	)

	rm build-aux/config.ld lib/posix/init.lua
}

each_lua_compile() {
	:; #wip
}
