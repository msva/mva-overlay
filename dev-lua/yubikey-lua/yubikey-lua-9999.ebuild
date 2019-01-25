# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="mercurial"
inherit lua

DESCRIPTION="Lua Asynchronous HTTP Library."
HOMEPAGE="http://code.matthewwild.co.uk/"
EHG_REPO_URI="http://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT LGPL-2.1+"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-lua/squish
"
DEPEND="${RDEPEND}"

each_lua_compile() {
	squish
}

each_lua_install() {
	dolua yubikey.lua
}
