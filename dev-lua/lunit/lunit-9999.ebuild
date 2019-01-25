# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="dcurrie"

inherit lua

DESCRIPTION="A unit testing framework for Lua"
HOMEPAGE="https://github.com/dcurrie/lunit"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

EXAMPLES=(examples/.)
DOCS=(README README.lunitx DOCUMENTATION)

each_lua_install() {
	dolua lua/*
}

all_lua_install() {
	dobin extra/"${PN}".sh
	dosym "${PN}.sh" /usr/bin/"${PN}"
}
