# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Feature-rich command line parser for Lua "
HOMEPAGE="https://github.com/mpeterv/argparse"
EGIT_REPO_URI="https://github.com/mpeterv/argparse"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins src/argparse.lua
}

src_install() {
	default
	lua_foreach_impl lua_install
}
