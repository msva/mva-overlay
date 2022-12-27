# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3 toolchain-funcs

DESCRIPTION="Binding of libevent for Lua"
HOMEPAGE="http://luaforge.net/projects/luaevent"
EGIT_REPO_URI="https://github.com/harningt/luaevent"

LICENSE="LGPL-2.1"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-libs/libevent:0=
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	local mysedargs=(
		-e "'s/CFLAGS ?=/CFLAGS +=/'"
		-e "'s/LDFLAGS ?=/LDFLAGS +=/'"
		-e "'s:-I\$(LUA_INC_DIR):\$(LUA_INC_DIR):'"
		-i Makefile
	)

	eval sed ${mysedargs[@]} || die
}

lua_src_compile() {
	tc-export CC

	emake LUA_INC_DIR="$(lua_get_CFLAGS)"
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_install() {
	local myemakeargs=(
		DESTDIR="${ED}"
		INSTALL_DIR_BIN="$(lua_get_cmod_dir)"
		INSTALL_DIR_LUA="$(lua_get_lmod_dir)"
		LUA_INC_DIR="$(lua_get_CFLAGS)"
	)

	emake ${myemakeargs[@]} install
}

src_install() {
	lua_foreach_impl lua_src_install
}
