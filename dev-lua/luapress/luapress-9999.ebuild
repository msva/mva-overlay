# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Static sites generator (from markdown files)"
HOMEPAGE="http://luapress.org"
EGIT_REPO_URI="https://github.com/Fizzadar/Luapress"

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-lua/luafilesystem[${LUA_USEDEP}]
	dev-lua/lustache[${LUA_USEDEP}]
	dev-lua/ansicolors[${LUA_USEDEP}]
	dev-lua/lua-discount[${LUA_USEDEP}]
	dev-lua/etlua[${LUA_USEDEP}]
"

src_prepare() {
	default

	mv "${PN}/${PN}.lua" "${S}/${PN}/init.lua"

	sed -r \
		-e '/local base/s@(")("\))$@\1/share/'"${PN}"'\2@' \
		-i "${PN}/init.lua"
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r "${PN}"
}

src_install() {
	lua_foreach_impl each_lua_install
	insinto "/usr/share/${PN}"
	doins -r template plugins
	dobin "bin/${PN}"
	if use examples; then
		DOCS+=(tests)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
