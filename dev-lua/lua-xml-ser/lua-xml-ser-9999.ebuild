# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="bibby"
inherit lua-broken

DESCRIPTION="A basic XML serializer for Lua"
HOMEPAGE="https://github.com/bibby/lua-xml-ser"

LICENSE="MIT"
SLOT="0"
IUSE="examples"

EXAMPLES=( test-xml-ser{,de}.lua )

each_lua_install() {
	dolua {list,xml-ser{,de}}.lua
}
