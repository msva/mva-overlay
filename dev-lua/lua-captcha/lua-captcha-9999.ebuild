# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua{5-{1..4},jit} )

inherit lua git-r3

DESCRIPTION="A small lua module to generate CAPTCHA images using lua-gd"
HOMEPAGE="https://github.com/mrDoctorWho/lua-captcha"
EGIT_REPO_URI="https://github.com/mrDoctorWho/lua-captcha"

LICENSE="MIT"
SLOT="0"
IUSE="jpeg png examples"

RDEPEND="
	${LUA_DEPS}
	dev-lua/lua-gd[${LUA_USEDEP}]
	media-libs/gd[jpeg=,truetype,png=]
"
DEPEND="${RDEPEND}"

REQUIRED_USE="
	${LUA_REQUIRED_USE}
	|| ( jpeg png )
"

src_compile() { :; }

each_lua_install() {
	insinto "$(lua_get_lmod_dir)"
	doins src/${PN//lua-}.lua
}

src_install() {
	lua_foreach_impl each_lua_install
	if use examples; then
		DOCS+=( examples )
		docompress -x /usr/share/doc/"${PF}"/examples
	fi
	einstalldocs
}
