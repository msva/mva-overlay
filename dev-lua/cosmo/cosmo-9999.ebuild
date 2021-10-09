# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VCS="git"
GITHUB_A="mascarenhas"
inherit lua-broken

DESCRIPTION="safe-template engine for lua"
HOMEPAGE="https://github.com/mascarenhas/cosmo"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples"

RDEPEND="
	|| (
		dev-lua/lpeg
		dev-lua/lulpeg[lpeg_replace]
	)
"

DOCS=( README doc/cosmo.md )
HTML_DOCS=( doc/index.html doc/cosmo.png )
EXAMPLES=( samples/sample.lua )

src_configure() { :; }
src_compile() { :; }

each_lua_install() {
	dolua src/*
}
