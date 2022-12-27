# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="Lua module for reading Linux input events from /dev/input/eventXX nodes"
HOMEPAGE="https://github.com/zhangxiangxiao/lua-evdev"
EGIT_REPO_URI="https://github.com/zhangxiangxiao/lua-evdev"

LICENSE="MIT"
SLOT="0"
IUSE="examples"

RDEPEND=""
DEPEND="
	${RDEPEND}
"

each_lua_prepare() {
	pushd "${BUILD_DIR}"
	if [[ "${ELUA}" == *jit ]]; then
		sed -r \
			-e '/^CFLAGS/s@\$\(COMPAT_CFLAGS\) -I.@@' \
			-e '/^CORE_C/s@(evdev/core.c) .*@\1@' \
			-i Makefile

		sed -r \
			-e '/#include "compat53\/compat-5.3.h"/d' \
			-i evdev/core.c
	fi
	popd
}

each_lua_compile() {
	pushd "${BUILD_DIR}"
	default
	popd
}

each_lua_install() {
	pushd "${BUILD_DIR}"
	insinto "$(lua_get_cmod_dir)/evdev"
	doins evdev/*.so
	insinto "$(lua_get_lmod_dir)/evdev"
	doins -r evdev/*.lua
	popd
}

src_prepare() {
	default
	sed -r \
		-e '1iCC ?= gcc' \
		-e '/^CFLAGS/s@$@ -I.@' \
		-e 's@gcc@\$\(CC\)@g' \
		-i Makefile
	mv evdev.lua evdev/init.lua
	lua_copy_sources
	lua_foreach_impl each_lua_prepare
}

src_compile() {
	lua_foreach_impl each_lua_compile
}
src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		mv example examples
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
