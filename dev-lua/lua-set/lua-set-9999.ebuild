# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="wscherphof"

inherit lua

DESCRIPTION="Straightforward Set library for Lua"
HOMEPAGE="https://github.com/wscherphof/lua-set"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_install() {
	dolua src/*
}
