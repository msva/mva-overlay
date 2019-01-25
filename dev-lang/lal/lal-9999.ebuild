# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
LUA_COMPAT="lua52 lua53"
GITHUB_A="WeirdConstructor"

inherit lua

DESCRIPTION="Session library for OpenResty implementing Secure Cookie Protocol"
HOMEPAGE="https://github.com/bungle/lua-resty-session"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND=""
DEPEND="
	${RDEPEND}
"

DOCS=(README.md doc/.)

all_lua_prepare() {
	local v;
	if has_version 'dev-lang/lua:5.3'; then
		v="5.3"
	elif has_version 'dev-lang/lua:5.2'; then
		v="5.2"
	else
		die "You need to install >=dev-lang/lua-5.2 first"
	fi
	sed -e "1i#!/usr/bin/env lua${v}" -i repl.lua
	lua_default
}

each_lua_install() {
	newbin repl.lua "${PN}"
	dolua "${PN}".lua
	_dolua_insdir="${PN}"
	dolua *.lua lang util
}
