# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Generates uuids in pure Lua"
HOMEPAGE="https://github.com/Tieske/uuid"
EGIT_REPO_URI="https://github.com/Tieske/uuid"

LICENSE="Apache-2.0"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"

HTML_DOCS=(docs/.)

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins "src/${PN}.lua"
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
