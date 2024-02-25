# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="MVC Web Framework for Lua"
HOMEPAGE="https://github.com/keplerproject/orbit"
EGIT_REPO_URI="https://github.com/keplerproject/orbit"

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-lua/wsapi[${LUA_USEDEP}]
	dev-lua/cosmo[${LUA_USEDEP}]
"
DEPEND="
	${RDEPEND}
"
DOCS=(md/. html)

src_prepare() {
	default
	mkdir -p html md
	mv doc/us/*.{html,css,png} html || die
	mv doc/us/*.md md || die
	rm configure Makefile || die
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r src/${PN}{,.lua}
}

src_install() {
	lua_foreach_impl each_lua_install
	dobin src/launchers/*
	if use examples; then
		rm samples/pages/doc samples/doc
		mv samples examples
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
