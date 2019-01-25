# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
IS_MULTILIB=true
GITHUB_A="harningt"
inherit lua

DESCRIPTION="libevent bindings for Lua"
HOMEPAGE="http://luaforge.net/projects/luaevent http://repo.or.cz/w/luaevent.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=dev-libs/libevent-1.4
"
DEPEND="
	${RDEPEND}
"

DOCS=(README)

each_lua_install() {
	dolua lua/*
	_dolua_insdir="${PN}" \
	dolua core.so
}
