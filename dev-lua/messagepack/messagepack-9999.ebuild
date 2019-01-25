# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="great90"
GITHUB_PN="lua-${PN^}"

inherit lua

DESCRIPTION="A pure Lua implementation of msgpack.org"
HOMEPAGE="https://fperrad.github.io/lua-MessagePack/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_install() {
	local insfrom;
	if [[ "${TARGET}" = "lua53" ]]; then
		insfrom=src5.3
	else
		insfrom=src
	fi

	dolua "${insfrom}"/MessagePack.lua
}
