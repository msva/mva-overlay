# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="brimworks"

inherit cmake-utils lua

DESCRIPTION="Lua bindings to zlib"
HOMEPAGE="https://github.com/brimworks/lua-zlib"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

each_lua_configure() {
	cmake-utils_src_configure
}

each_lua_install() {
	dolua "${PN//lua-}".so
}
