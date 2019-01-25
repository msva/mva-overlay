# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
LUA_COMPAT="lua51 lua52 lua53 luajit2"
GITHUB_A="mpeterv"

inherit lua

DESCRIPTION="Feature-rich command line parser for Lua "
HOMEPAGE="https://github.com/mpeterv/argparse"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

DOCS=(README.md)

each_lua_install() {
	dolua "src/${PN}.lua"
}
