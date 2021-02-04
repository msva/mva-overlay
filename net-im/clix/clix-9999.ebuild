# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mercurial eutils

DESCRIPTION="XMPP client library written in Lua."
HOMEPAGE="http://code.matthewwild.co.uk/"
EHG_REPO_URI="http://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	virtual/lua[luajit=]
	dev-lua/squish
	dev-lua/verse
	dev-lua/luaexpat
"
DEPEND="${RDEPEND}"

src_prepare() {
	use luajit && sed -r \
		-e '1s:(env lua):\1jit:' \
		-i clix.lua

	default
}

src_compile() {
	squish
}

src_install() {
	newbin clix.bin clix
	dodoc README
}
