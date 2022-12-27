# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 toolchain-funcs

DESCRIPTION="Lua driver for LDAP"
HOMEPAGE="https://github.com/lualdap/lualdap"
EGIT_REPO_URI="https://github.com/lualdap/lualdap"

LICENSE="MIT"
SLOT="0"
IUSE="doc examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	net-nds/openldap
"
DEPEND="${RDEPEND}"

HTML_DOCS=(docs/.)

src_prepare() {
	default
	sed -i -e 'd' config
	sed \
		-e '/#define luaL_newlib(/s@^@#ifndef luaL_newlib\n@' \
		-e '/(luaL_newlibtable(L, (l)), luaL_setfuncs(L, (l), 0))/s@$@\n#endif@' \
		-i src/"${PN}".c || die
	lua_copy_sources
}

each_lua_compile() {
	local cf=(
		${CFLAGS} -fPIC
		$(lua_get_CFLAGS)
		$($(tc-getPKG_CONFIG) --cflags ldap || die "Can't find openldap")
		-shared src/"${PN}".c
		$($(tc-getPKG_CONFIG) --libs ldap || die "Can't find openldap")
		${LDFLAGS}
		-o ${PN}.so
	)
	pushd "${BUILD_DIR}"
		echo $(tc-getCC) ${cf[@]}
		$(tc-getCC) ${cf[@]} || die "Failed to compile"
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
