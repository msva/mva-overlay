# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="aiq"
inherit lua

DESCRIPTION="A simple implementation of OATH-HOTP and OATH-TOTP written for Lua"
HOMEPAGE="https://github.com/aiq/basexx"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc test"

DEPEND="
	${RDEPEND}
	test? ( dev-lua/busted )
"

DOCS=(README.adoc)

each_lua_test() {
	for t in test/*; do
		busted "${t}"
	done
}

each_lua_install() {
	dolua lib/basexx.lua
}
