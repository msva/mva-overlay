# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A library for time and date manipulation"
HOMEPAGE="https://github.com/daurnimator/luatz"
EGIT_REPO_URI="https://github.com/daurnimator/luatz"

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r "${PN}"
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	rm doc/README.md # useless, unlike the one in repo's root, that included by default
	DOCS+=(doc/*.md)
	einstalldocs
}
