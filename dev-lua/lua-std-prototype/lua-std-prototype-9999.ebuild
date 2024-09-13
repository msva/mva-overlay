# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Prototype Oriented Programming with Lua"
HOMEPAGE="https://github.com/lua-stdlib/prototype"
EGIT_REPO_URI="https://github.com/lua-stdlib/prototype"

LICENSE="MIT"
SLOT="0"
IUSE="doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-lua/lua-std-normalize[${LUA_USEDEP}]
"
DEPEND="
	${RDEPEND}
	doc? ( dev-lua/ldoc )
"
each_lua_compile() {
	pushd "${BUILD_DIR}"
	default
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/std
	popd
}

src_prepare() {
	default

	sed -i -r \
		-e '/^all/{s@doc @@}' \
		Makefile || die

	lua_copy_sources
}

src_compile() {
	lua_foreach_impl each_lua_compile
	if use doc; then
		emake doc
	fi
}

src_install() {
	lua_foreach_impl each_lua_install
	if use doc; then
		HTML_DOCS=(doc/.)
	fi
	einstalldocs
}
