# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="kikito"
GITHUB_PN="${PN}.lua"

inherit lua

DESCRIPTION="Human-readable representation of lua-tables"
HOMEPAGE="https://github.com/kikito/inspect.lua"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_install() {
	dolua "${PN}".lua
}
