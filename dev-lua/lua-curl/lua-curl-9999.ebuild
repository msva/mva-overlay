# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua cURL Library"
HOMEPAGE="https://github.com/Lua-cURL/Lua-cURLv3"
EGIT_REPO_URI="https://github.com/Lua-cURL/Lua-cURLv3"

LICENSE="MIT"
SLOT="0"
IUSE="doc examples"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	net-misc/curl
	${LUA_DEPS}
"
DEPEND="
	doc? ( dev-lua/ldoc )
	${RDEPEND}
"

src_prepare() {
	default
	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	LUA_IMPL="${ELUA}"
	default
	popd
}

src_compile() {
	if use doc; then
		cd doc
		ldoc . -d ../html
		cd -
	fi
	lua_foreach_impl each_lua_compile
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	LUA_IMPL="${ELUA}"
	default
	popd
}

src_install() {
	lua_foreach_impl each_lua_install
	if use doc; then
		HTML_DOCS+=(html/.)
	fi
	if use examples; then
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
