# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 toolchain-funcs

DESCRIPTION="Lua driver for LDAP"
HOMEPAGE="https://github.com/mwild1/lualdap/"
EGIT_REPO_URI="https://github.com/mwild1/lualdap/"

LICENSE="MIT"
SLOT="0"
IUSE="doc examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	net-nds/openldap
"
DEPEND="${RDEPEND}"

HTML_DOCS=(doc/us/.)

src_prepare() {
	default
	sed -i -e 'd' config
	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -lldap -fPIC -shared -o "${PN}".so || die
	popd
}

#each_lua_test() {
#	Requires LDAP server
#	${LUA} tests/test.lua <hostname>[:port] <base> [<who> [<password>]]
#}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins "${PN}".so
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		mv tests examples
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
