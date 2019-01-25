# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="dawnangel"
GITHUB_PN="lua-${PN}"

inherit lua

DESCRIPTION="Lua client for NATS messaging system"
HOMEPAGE="https://github.com/dawnangel/lua-nats"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

RDEPEND="
	dev-lua/lua-cjson
	dev-lua/luasocket
	dev-lua/uuid
"
DEPEND="
	${RDEPEND}
"

DOCS=(README.md)
#HTML_DOCS=(docs/.)
EXAMPLES=({examples,tests}/.)

#all_lua_compile() {
#	use doc && ldoc .
#}
#
#each_lua_compile() { :; }
# Makefile is only used to run tests
# and ldoc is currently broken
src_compile() { :; }

each_lua_install() {
	dolua "src/${PN}.lua"
}
