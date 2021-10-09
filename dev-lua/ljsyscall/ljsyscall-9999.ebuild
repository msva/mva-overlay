# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
LUA_COMPAT="luajit2"
GITHUB_A="justincormack"
inherit lua-broken

DESCRIPTION="LuaJIT Unix syscall FFI"
HOMEPAGE="https://github.com/justincormack/ljsyscall"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples"

RDEPEND="
	virtual/libc
"
DEPEND="${RDEPEND}"

DOCS=( README.md doc/. )
EXAMPLES=( examples/. )

each_lua_install() {
	dolua syscall syscall.lua
}
