# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua messagepack for ngx_lua/stream_lua/OpenResty"
HOMEPAGE="https://github.com/chronolaw/lua-resty-msgpack"
EGIT_REPO_URI="https://github.com/chronolaw/lua-resty-msgpack"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
IUSE="+messagepack-compat"

src_configure() { :; }
src_compile() { :; }

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	use messagepack-compat && newins lib/resty/msgpack.lua MessagePack.lua
	insinto "$(lua_get_lmod_dir)/resty"
	doins lib/resty/msgpack.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
