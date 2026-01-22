# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua coxpcall Library"
HOMEPAGE="https://framagit.org/fperrad/lua-MessagePack"
EGIT_REPO_URI="https://framagit.org/fperrad/lua-MessagePack"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"

DOCS=( docs/. README.md )

src_configure() { :; }
src_compile() { :; }

each_lua_install() {
	local src="src"
	if [[ "${ELUA}" =~ lua5.[34] ]]; then
		src="src5.3"
	fi
	insinto "$(lua_get_lmod_dir)"
	doins "${src}"/MessagePack.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
