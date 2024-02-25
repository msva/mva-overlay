# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua-single mercurial

DESCRIPTION="Squish Lua libraries and apps into a single compact file"
HOMEPAGE="https://code.matthewwild.co.uk/"
EHG_REPO_URI="https://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT"
SLOT="0"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	$(lua_gen_cond_dep '
		dev-lua/luasocket[${LUA_USEDEP}]
	')
"
DEPEND="${RDEPEND}"

src_install() {
	dobin squish
	dobin make_squishy
	dodoc README
}
