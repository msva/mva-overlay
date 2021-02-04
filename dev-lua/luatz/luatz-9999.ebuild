# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="daurnimator"

inherit lua

DESCRIPTION="A library for time and date manipulation"
HOMEPAGE="https://github.com/daurnimator/luatz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

DOCS=(doc/.)
EXAMPLES=(examples/.)

each_lua_install() {
	dolua "${PN}"
}
