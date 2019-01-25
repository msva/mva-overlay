# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="Olivine-Labs"

inherit lua

DESCRIPTION="A small lua module to generate CAPTCHA images using lua-gd"
HOMEPAGE="http://olivinelabs.com/lustache"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples"

DOCS=(README.md)
EXAMPLES=(spec/.)

src_compile() { :; }

each_lua_install() {
	dolua src/*
}
