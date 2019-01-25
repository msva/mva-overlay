# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="lua-stdlib"

inherit lua

DESCRIPTION="Standard Lua libraries"
HOMEPAGE="https://github.com/lua-stdlib/lua-stdlib"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

DOCS=(README.md NEWS.md STYLE.md)

all_lua_prepare() {
	lua_default
	mkdir -p html
	sed \
		-e '/^dir/s@"."@"../html"@' \
		-i doc/config.ld.in
}

each_lua_compile() { :; }
# ldoc definitions are currently broken
all_lua_compile() { :; }

each_lua_install() {
	dolua lib/std
}
