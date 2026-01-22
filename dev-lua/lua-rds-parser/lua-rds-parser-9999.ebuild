# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Resty-DBD-Stream (RDS) parser for Lua written in C"
HOMEPAGE="https://github.com/openresty/lua-rds-parser"
EGIT_REPO_URI="https://github.com/openresty/lua-rds-parser"

LICENSE="BSD"
SLOT="0"
RDEPEND="
	${LUA_DEPS}
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	emake "LUA_INCLUDE_DIR=$(lua_get_include_dir)"
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	emake "PREFIX=/usr" "LUA_LIB_DIR=$(lua_get_cmod_dir)" DESTDIR="${D}" install
	popd
}

src_configure() { :; }

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
