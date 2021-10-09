# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT="luajit2"
VCS="git"
GITHUB_A="sjnam"
GITHUB_PN="luajit-${PN##resty-}"

inherit lua-broken

DESCRIPTION="LuaJIT bindings for dev-libs/xxhash"
HOMEPAGE="https://github.com/sjnam/luajit-xxhash"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/xxhash"
DEPEND="${RDEPEND}"

DOCS=(README.md)

each_lua_install() {
	dolua_jit lib/resty
}
