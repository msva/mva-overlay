# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit lua git-r3

DESCRIPTION="LuaJIT bindings for dev-libs/xxhash"
HOMEPAGE="https://github.com/sjnam/luajit-xxhash"
EGIT_REPO_URI="https://github.com/sjnam/luajit-xxhash"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-libs/xxhash
"
DEPEND="${RDEPEND}"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins "${PN//luajit-}".lua
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
