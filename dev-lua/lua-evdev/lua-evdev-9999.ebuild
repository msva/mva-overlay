# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
LUA_COMPAT="lua51 lua52 lua53 luajit2"
GITHUB_A="Tangent128"
GITHUB_A="zhangxiangxiao"

inherit lua

DESCRIPTION="Lua module for reading Linux input events from /dev/input/eventXX nodes"
HOMEPAGE="https://github.com/Tangent128/lua-evdev"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples"

RDEPEND=""
DEPEND="
	${RDEPEND}
"

DOCS=(README.md)
EXAMPLES=(example/.)

all_lua_prepare() {
	sed -r \
		-e '1iCC ?= gcc' \
		-e '/^CFLAGS/s@$@ -I.@' \
		-e 's@gcc@\$\(CC\)@g' \
		-i Makefile
	lua_default
}

each_lua_prepare() {
	lua_is_jit && (
		sed -r \
			-e '/^CFLAGS/s@\$\(COMPAT_CFLAGS\) -I.@@' \
			-e '/^CORE_C/s@(evdev/core.c) .*@\1@' \
			-i Makefile
		sed -r \
			-e '/#include "compat53\/compat-5.3.h"/d' \
			-i evdev/core.c
	)
	lua_default
}

each_lua_install() {
	rm evdev/core.c
	dolua evdev evdev.lua
}
