# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua

DESCRIPTION="A set of Lua bindings for the Fast Artificial Neural Network (FANN) library."
HOMEPAGE="https://github.com/msva/lua-fann"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/msva/lua-fann"
else
	KEYWORDS="~amd64 ~ppc ~x86"
	# not available on fann: ~arm{,64} and ~mips
	SRC_URI="https://github.com/msva/lua-fann/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	sci-mathematics/fann
"
DEPEND="
	${RDEPEND}
"

each_lua_compile() {
	pushd "${BUILD_DIR}"
	emake \
		LUA_IMPL="${ELUA}" \
		LUA_BIN="${ELUA}" \
		LUA_INC="."
	popd
}

each_lua_test() {
	pushd "${BUILD_DIR}"
	emake test
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)"
	doins fann.so
	popd
}

each_lua_prepare() {
	pushd "${BUILD_DIR}"
	if [[ "${ELUA}" == "luajit" ]]; then
		sed \
			-e '/^static void luaL_setfuncs/,/^}/d' \
			-e '/^#define luaL_newlib/d' \
			-i src/fann.c
	fi
	popd
}

src_prepare() {
	default
	lua_copy_sources
	lua_foreach_impl each_lua_prepare
}

src_compile() {
	if use doc; then
		emake docs
	fi
	lua_foreach_impl each_lua_compile
}

src_test() {
	lua_foreach_impl each_lua_test
}

src_install() {
	if use doc; then
		HTML_DOCS=(doc/luafann.html)
	fi

	lua_foreach_impl each_lua_install
	einstalldocs
}
