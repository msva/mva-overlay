# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="msva"

inherit lua

DESCRIPTION="Parse HTML text into a tree of elements with selectors"
HOMEPAGE="https://github.com/msva/lua-htmlparser"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_install() {
	dolua src/*
}
