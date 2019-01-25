# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="mercurial"
inherit lua

DESCRIPTION="Lua feeds parsing library"
HOMEPAGE="http://code.matthewwild.co.uk/lua-feeds"
EHG_REPO_URI="http://code.matthewwild.co.uk/lua-feeds"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples"

DEPEND="
	${RDEPEND}
	dev-lua/squish
"

EXAMPLES=(demo.lua demo_string.lua)

each_lua_compile() {
	squish
}

each_lua_install() {
	newlua feeds{.min,}.lua
}
