# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
IS_MULTILIB=true
GITHUB_A="ittner"

inherit lua

DESCRIPTION="Lua bindings for POSIX iconv"
HOMEPAGE="http://ittner.github.com/lua-iconv"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_install() {
	dolua iconv.so
}
