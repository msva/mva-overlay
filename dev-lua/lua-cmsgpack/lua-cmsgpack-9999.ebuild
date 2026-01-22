# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )
MY_PN="${PN//lua-}"

inherit lua git-r3 toolchain-funcs

DESCRIPTION="A self contained Lua MessagePack C implementation"
HOMEPAGE="https://github.com/antirez/lua-cmsgpack"
EGIT_REPO_URI="https://github.com/antirez/lua-cmsgpack"

LICENSE="BSD-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"

each_lua_compile() {
	pushd "${BUILD_DIR}"
	$(tc-getCC) -fPIC ${CFLAGS} $(lua_get_CFLAGS) ${LDFLAGS} -shared ${PN//-/_}.c -o ${MY_PN}.so || die
	popd
}

each_lua_test() {
	pushd "${BUILD_DIR}"
	${ELUA} test.lua || die
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins "${MY_PN}.so"
	popd
}

src_prepare() {
	default
	lua_copy_sources
}

src_test() {
	lua_foreach_impl each_lua_test
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
