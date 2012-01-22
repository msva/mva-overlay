# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib toolchain-funcs flag-o-matic mercurial eutils

DESCRIPTION="XMPP client library written in Lua."
HOMEPAGE="http://code.mathewwild.co.uk/"
EHG_REPO_URI="http://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-lang/lua-5.1
	dev-lua/squish
	dev-lua/verse
	dev-lua/luaexpat"
DEPEND="${RDEPEND}"

src_compile() {
squish
}

src_install() {
	#insinto $(pkg-config --variable INSTALL_LMOD lua)
	newbin clix.bin clix || die
}
