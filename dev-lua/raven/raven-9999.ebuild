# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A small Lua interface to Sentry"
HOMEPAGE="https://github.com/cloudflare/raven-lua"
EGIT_REPO_URI="https://github.com/cloudflare/raven-lua"

LICENSE="MIT"
SLOT="0"
IUSE="doc test examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-lua/lua-cjson[${LUA_USEDEP}]
	doc? ( dev-lua/ldoc[${LUA_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	test? (
		dev-lua/lunit[${LUA_USEDEP}]
		dev-lua/luaposix[${LUA_USEDEP}]
	)
"

src_compile() {
	if use doc; then
		ldoc .
	fi
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r raven
}

src_install() {
	lua_foreach_impl each_lua_install
	if use doc; then
		HTML_DOCS=(html/.)
	fi
	if use examples; then
		mv tests examples
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
