# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Standard Lua libraries"
HOMEPAGE="https://github.com/lua-stdlib/lua-stdlib"
EGIT_REPO_URI="https://github.com/lua-stdlib/lua-stdlib"

LICENSE="MIT"
SLOT="0"
IUSE="doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
DEPEND="
	${RDEPEND}
	doc? ( dev-lua/ldoc )
"

src_prepare() {
	default
	sed \
		-e '/^all:/s@ doc@$(luadir)/version.lua@' \
		-e "/^VERSION/s@git@${PV}@" \
		-i Makefile || die
	sed \
		-e '/Module = /d' \
		-e '/mapfields = /d' \
		-i lib/std/_base.lua || die
	lua_copy_sources
}

each_lua_compile() {
	default
}

src_compile() {
	if use doc; then
		emake doc
	fi
	lua_foreach_impl each_lua_compile
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/std
}

src_install() {
	lua_foreach_impl each_lua_install
	use doc && HTML_DOCS=(doc/.)
	einstalldocs
}
