# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

#EGIT_BRANCH="v14.1"

DESCRIPTION="A testing tool for Lua, providing a Behaviour Driven Development"
HOMEPAGE="https://github.com/gvvaughan/specl"
EGIT_REPO_URI="https://github.com/gvvaughan/specl"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
IUSE="doc"

RDEPEND="
	${LUA_DEPS}
	dev-lua/luamacro[${LUA_USEDEP}]
	dev-lua/lyaml[${LUA_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-lua/lyaml[${LUA_USEDEP}]
	dev-lua/lua-std-normalize[${LUA_USEDEP}]
	doc? (
		dev-lua/ldoc[${LUA_USEDEP}]
		sys-apps/help2man
	)
"

DOCS=(README.md doc/specl.md NEWS.md)

src_prepare() {
	default
	mv "${S}"/lib/specl/version-git.lua "${S}"/lib/specl/version.lua || die
	sed \
		-e '/^all:/{s@ doc@@;s@ doc/specl.1@@}' \
		-i "${S}"/Makefile || die
	sed \
		-e "s@debug_init'._DEBUG@_debug'@g" \
		-i "${S}"/lib/specl/std.lua || die
	lua_copy_sources
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	LUA_PATH="/var/tmp/portage/dev-lua/specl-9999/work/specl-9999/lib/?.lua;;"
	default
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	rm lib/specl/version.lua.in || die
	insinto "$(lua_get_lmod_dir)"
	doins -r lib/specl
	popd
}

src_compile() {
	if use doc; then
		emake doc
		#doc/specl.1
		# specl is broken for now, and making man requires it to work
	fi
	lua_foreach_impl each_lua_compile
}

src_install() {
	lua_foreach_impl each_lua_install
	if use doc; then
		HTML_DOCS=(doc/.)
		#doman doc/specl.1
		#rm doc/specl.1
	fi
	dobin bin/specl
	einstalldocs
}
