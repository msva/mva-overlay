# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="mercurial"
inherit lua

DESCRIPTION="System statistics library for Lua"
HOMEPAGE="http://code.matthewwild.co.uk/"
EHG_REPO_URI="http://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples"

EXAMPLES=( demo.lua )

all_lua_prepare() {
	sed -r \
		-e "s#(require.*)(proc.*)#\1${PN}.\2#" \
		-i init.lua

	mkdir -p ${PN}
	mv {init,proc}.lua ${PN}
}

each_lua_install() {
	dolua ${PN}
}
