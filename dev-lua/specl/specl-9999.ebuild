# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="gvvaughan"

inherit autotools lua

EGIT_BRANCH="v14.1"

DESCRIPTION="A testing tool for Lua, providing a Behaviour Driven Development"
HOMEPAGE="https://github.com/gvvaughan/specl"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="${RDEPEND}
	dev-lua/luamacro
	dev-lua/lyaml
"
DEPEND="${DEPEND}
	dev-lua/lyaml
	dev-lua/lua-std-normalize
"

DOCS=(README.md doc/specl.md NEWS.md)
HTML_DOCS=(doc/.)
#DOC_MAKE_TARGET="doc/specl.1"

all_lua_prepare() {
	lua_default
	touch Makefile.am # Yup, kludges
	eautoreconf
}

each_lua_install() {
	dobin bin/specl
	rm lib/specl/version.lua.in # and here too
	dolua lib/specl
}
