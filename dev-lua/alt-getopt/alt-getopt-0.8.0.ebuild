# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua

DESCRIPTION="Lua API for getopt similar to getopt_long(3)"
HOMEPAGE="https://github.com/cheusov/lua-alt-getopt"
MY_P="lua-${P}"
SRC_URI="https://github.com/cheusov/lua-${PN}/archive/refs/tags/${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"

S="${WORKDIR}/lua-${P}"

src_compile() { :; }

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins "${PN//-/_}".lua
}

src_install() {
	lua_foreach_impl each_lua_install
	dobin "${PN//-/_}"
	einstalldocs
}
