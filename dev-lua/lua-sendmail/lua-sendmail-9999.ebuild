# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="moteus"

inherit lua

DESCRIPTION="Simple wrapper around luasoket smtp.send"
HOMEPAGE="https://github.com/moteus/lua-sendmail"

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

DOCS=(README.md)
HTML_DOCS=(docs/.)

each_lua_install() {
	dolua lua/sendmail.lua
}
