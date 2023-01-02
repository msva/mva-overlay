# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A simple implementation of OATH-HOTP and OATH-TOTP written for Lua"
HOMEPAGE="https://github.com/remjey/luaotp"
EGIT_REPO_URI="https://github.com/remjey/luaotp"

LICENSE="MIT"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-lua/luaossl[${LUA_USEDEP}]
	dev-lua/basexx[${LUA_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? ( dev-lua/busted[${LUA_USEDEP}] )
"

DOCS=(README.md doc/.)

each_lua_test() {
	for t in spec/*; do
		busted "${t}"
	done
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins src/otp.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
