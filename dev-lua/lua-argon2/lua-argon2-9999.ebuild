# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 toolchain-funcs

DESCRIPTION="Lua C binding for the Argon2 password hashing function"
HOMEPAGE="https://github.com/thibaultcha/lua-argon2"
EGIT_REPO_URI="https://github.com/thibaultcha/lua-argon2"

LICENSE="MIT"
SLOT="0"
IUSE="doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	app-crypt/argon2
"
DEPEND="
	${RDEPEND}
"

each_lua_setup() {
	if [[ "${ELUA}" == "luajit" ]]; then
		einfo "Seems like you're installing this package for LuaJIT target."
		einfo "Although, it should be compatible, you may prefer to use FFI version instead:"
		einfo "  dev-lua/lua-argon2-ffi"
	fi
}

pkg_setup() {
	lua_foreach_impl each_lua_setup
}

src_prepare() {
	default
	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	$(tc-getCC) ${CFLAGS} -fPIC -shared "src/${PN#lua-}.c" ${LDFLAGS} -largon2 -o "${PN#lua-}.so" || die
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins argon2.so
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
