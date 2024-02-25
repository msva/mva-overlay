# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )

inherit lua git-r3

DESCRIPTION="LuaJIT Unix syscall FFI"
HOMEPAGE="https://github.com/justincormack/ljsyscall"
EGIT_REPO_URI="https://github.com/justincormack/ljsyscall"

LICENSE="MIT"
SLOT="0"
IUSE="examples"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	virtual/libc
"
DEPEND="${RDEPEND}"

DOCS=( README.md doc/. )

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r syscall syscall.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		DOCS+=(examples)
		docmopress -x "/usr/share/doc/${PF}/examples"
	fi
	einstalldocs
}
