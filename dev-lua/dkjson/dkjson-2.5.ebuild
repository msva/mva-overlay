# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit lua

DESCRIPTION="David Kolf's JSON module for Lua"
HOMEPAGE="http://dkolf.de/src/dkjson-lua.fsl/"
SRC_URI="http://dkolf.de/src/dkjson-lua.fsl/tarball/${P}.tar.gz?uuid=release_2_5 -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
#KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86" # ppc64 is dropped from luajit in gentoo repo
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

DOCS_FORCE=(readme.txt)

each_lua_install() {
	dolua "${PN}".lua
}
