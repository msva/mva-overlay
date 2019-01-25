# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mercurial

DESCRIPTION="XMPP client library written in Lua."
HOMEPAGE="http://code.matthewwild.co.uk/"
EHG_REPO_URI="http://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-lua/luasocket
	virtual/lua
"
DEPEND="${RDEPEND}"

src_install() {
	dobin squish
	dobin make_squishy
	dodoc README
}
