# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="safe-template engine for lua"
HOMEPAGE="https://github.com/mascarenhas/cosmo"
EGIT_REPO_URI="https://github.com/mascarenhas/cosmo"

LICENSE="MIT"
SLOT="0"
IUSE="+examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	|| (
		dev-lua/lpeg[${LUA_USEDEP}]
		dev-lua/lulpeg[${LUA_USEDEP},lpeg-replace]
	)
"
DEPEND="${RDEPEND}"

DOCS+=(doc/cosmo.md)
HTML_DOCS=( doc/index.html doc/cosmo.png )

src_configure() { :; }
src_compile() { :; }

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r "src/${PN}"{,.lua}
}
src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		mv samples examples
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/"
	fi
	einstalldocs
}
