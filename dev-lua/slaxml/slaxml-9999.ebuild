# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="Phrogz"
inherit lua

DESCRIPTION="A basic XML serializer for Lua"
HOMEPAGE="https://github.com/bibby/lua-xml-ser"

LICENSE="MIT"
SLOT="0"
IUSE="+examples"

EXAMPLES=( test/. )

each_lua_install() {
	dolua *.lua
}
