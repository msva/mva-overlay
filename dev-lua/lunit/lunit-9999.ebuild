# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A unit testing framework for Lua"
HOMEPAGE="https://github.com/dcurrie/lunit"
EGIT_REPO_URI="https://github.com/dcurrie/lunit"

LICENSE="MIT"
SLOT="0"
IUSE="examples"

DOCS=(README README.lunitx DOCUMENTATION)

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r lua/*
}

src_install() {
	lua_foreach_impl each_lua_install
	dobin extra/"${PN}".sh
	dosym "${PN}.sh" /usr/bin/"${PN}"
	if use examples; then
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
