# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="The most comprehensive CBOR module in the Lua universe"
HOMEPAGE="https://github.com/spc476/CBOR"
EGIT_REPO_URI="https://github.com/spc476/CBOR"

LICENSE="MIT"
SLOT="0"
IUSE="doc +examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	|| (
		dev-lua/lpeg[${LUA_USEDEP}]
		dev-lua/lulpeg[${LUA_USEDEP},lpeg-replace]
	)
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	if use examples; then
		mkdir -p examples
		cp test*.lua examples
	fi
	sed -r \
		-e 's@^(prefix).*@\1=/usr@' \
		-e 's@(.*LUA_DIR.*/lua/.*shell )lua( -e "print.*)@\1${ELUA}\2@' \
		-i Makefile
	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	default
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	default
	popd
}

src_compile() {
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
