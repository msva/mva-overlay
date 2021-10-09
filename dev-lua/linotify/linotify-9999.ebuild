# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

IS_MULTILIB=true
VCS="git"
GITHUB_A="hoelzro"

inherit lua-broken

DESCRIPTION="inotify bindings for Lua"
HOMEPAGE="https://github.com/hoelzro/linotify"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="virtual/libc"

DOCS=(README.md)

each_lua_compile() {
	lua_default LUAPKG_CMD="${lua_impl}"
}

each_lua_install() {
	dolua inotify.so
}
