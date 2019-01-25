# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="hugomg"

inherit lua

DESCRIPTION="A stream-based HTML template library for Lua."
HOMEPAGE="https://github.com/hugomg/lullaby"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

DOCS=(README.md)
HTML_DOCS=(htmlspec/.)

each_lua_install() {
	dolua lullaby.lua lullaby
}
