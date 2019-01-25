# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="remjey"

inherit lua

DESCRIPTION="A simple implementation of OATH-HOTP and OATH-TOTP written for Lua"
HOMEPAGE="https://github.com/remjey/luaotp"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc test"

RDEPEND="
	dev-lua/luaossl
	dev-lua/basexx
"
DEPEND="
	${RDEPEND}
	test? ( dev-lua/busted )
"

DOCS=(README.md doc/.)

each_lua_test() {
	for t in spec/*; do
		busted "${t}"
	done
}

each_lua_install() {
	dolua src/otp.lua
}
