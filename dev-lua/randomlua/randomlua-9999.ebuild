# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="linux-man"

inherit lua

DESCRIPTION="Pure Lua Random Generator"
HOMEPAGE="https://github.com/linux-man/randomlua"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=""
DEPEND="
	${RDEPEND}
"

DOCS=(README.md)

each_lua_install() {
	dolua "${PN}.lua"
}
