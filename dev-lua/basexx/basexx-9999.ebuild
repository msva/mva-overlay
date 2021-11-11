# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A simple implementation of OATH-HOTP and OATH-TOTP written for Lua"
HOMEPAGE="https://github.com/aiq/basexx"
EGIT_REPO_URI="https://github.com/aiq/basexx"

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
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
	insinto "$(lua_get_lmod_dir)"
	doins lib/"${PN}".lua
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
