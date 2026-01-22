# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A FastCGI server for Lua, written in C"
HOMEPAGE="https://github.com/cramey/lua-fastcgi"
EGIT_REPO_URI="https://github.com/cramey/lua-fastcgi"
EGIT_BRANCH="public"

LICENSE="MIT"
SLOT="0"

REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-libs/fcgi
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -r \
		-e 's/-Wl,[^ ]*//g' \
		-i Makefile

	sed \
		-e "s#lua5.1/##" \
		-i src/config.c src/lfuncs.c src/lua.c src/lua-fastcgi.c

	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	default
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	newbin ${PN} ${PN}-${ELUA}
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	DOCS+=(${PN}.lua)
	einstalldocs
}
