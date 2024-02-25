# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua mercurial

DESCRIPTION="System statistics library for Lua"
HOMEPAGE="https://code.matthewwild.co.uk/"
EHG_REPO_URI="https://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -r \
		-e "s@(require.*)(proc.*)@\1${PN}.\2@" \
		-i init.lua

	mkdir -p ${PN}
	mv {init,proc}.lua ${PN}
}

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r ${PN}
}
src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		mkdir examples -p
		mv demo.lua examples
		DOCS+=(examples)
		docompress -x /usr/share/doc/"${PF}"/examples
	fi
	einstalldocs
}
