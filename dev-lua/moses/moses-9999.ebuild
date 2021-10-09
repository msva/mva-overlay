# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="Yonaba"
GITHUB_PN="${PN^}"

inherit lua-broken

DESCRIPTION="Simple wrapper around luasoket smtp.send"
HOMEPAGE="https://github.com/Yonaba/Moses"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	dev-lua/luasocket
"
DEPEND="
	${RDEPEND}
"

DOCS=(README.md doc/tutorial.md)
HTML_DOCS=(doc/index.html doc/manual)

each_lua_install() {
	dolua ${PN}.lua
}
