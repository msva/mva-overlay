# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="cloudflare"
GITHUB_PN="${PN}-lua"

inherit lua

DESCRIPTION="A small Lua interface to Sentry"
HOMEPAGE="https://github.com/cloudflare/raven-lua"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc test examples"

RDEPEND="
	dev-lua/lua-cjson
"
#	doc? ( dev-lua/ldoc )
DEPEND="
	${RDEPEND}
	test? (
		dev-lua/lunit
		dev-lua/luaposix
	)
"

DOCS=(README.md)
#HTML_DOCS=(docs/.)
EXAMPLES=(tests/.)

#all_lua_compile() {
#	use doc && ldoc .
#}
#
#each_lua_compile() { :; }
# Makefile is only used to run tests
# and ldoc is currently broken
src_compile() { :; }

each_lua_install() {
	dolua raven
}
