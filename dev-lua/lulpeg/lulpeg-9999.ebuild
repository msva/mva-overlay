# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A pure Lua port of dev-lua/lpeg"
HOMEPAGE="https://github.com/pygy/LuLPeg"
EGIT_REPO_URI="https://github.com/pygy/LuLPeg"

LICENSE="WTFPL-2 MIT"
# ^ author claims that it's WTFPL-3, actually, but even wiki doesn't know about it

SLOT="0"
IUSE="doc lpeg-replace"

REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	lpeg-replace? ( !dev-lua/lpeg )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	lua_copy_sources
}
each_lua_compile() {
	pushd "${BUILD_DIR}/src"
	"${ELUA}" ../scripts/pack.lua > ../"${PN}.lua"
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_lmod_dir)"
	doins "${PN}".lua
	use lpeg-replace && newins "${PN}.lua" lpeg.lua
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
