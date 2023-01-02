# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua-single mercurial

DESCRIPTION="Lua to HTML code converter written in Lua."
HOMEPAGE="https://code.matthewwild.co.uk/"
EHG_REPO_URI="https://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
#RESTRICT="network-sandbox"
# ^ :(
# uses squish, which fetches some sources during build

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
# BDEPEND="dev-lua/squish"

#src_compile() {
#	squish
#}

src_install() {
	newbin "${PN}.lua" "${PN}"
}
