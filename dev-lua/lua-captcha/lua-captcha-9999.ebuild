# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="mrDoctorWho"

inherit lua

DESCRIPTION="A small lua module to generate CAPTCHA images using lua-gd"
HOMEPAGE="https://github.com/mrDoctorWho/lua-captcha"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="jpeg png examples"

DOCS=(README.md)
EXAMPLES=(examples/.)

RDEPEND="
	dev-lua/lua-gd
	media-libs/gd[jpeg=,truetype,png=]
"

REQUIRED_USE="|| ( jpeg png )"

src_compile() { :; }

each_lua_install() {
	dolua src/*
}
