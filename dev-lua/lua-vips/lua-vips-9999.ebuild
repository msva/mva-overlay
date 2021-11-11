# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit lua git-r3

DESCRIPTION="fast, low-memory-use image processing for luajit"
HOMEPAGE="https://github.com/jcupitt/lua-vips"
EGIT_REPO_URI="https://github.com/jcupitt/lua-vips"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	>media-libs/vips-8.0.0
"
DEPEND="
	${RDEPEND}
"

src_compile() { :; }

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r src/*
}

src_install() {
	lua_foreach_impl each_lua_install
	einstalldocs
}
