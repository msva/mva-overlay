# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib toolchain-funcs flag-o-matic cvs eutils

DESCRIPTION="Lua Crypto Library"
HOMEPAGE="http://code.mathewwild.co.uk/"
SRC_URI=""

ECVS_SERVER="cvs.${PN}.berlios.de:/cvsroot/${PN}"
ECVS_MODULE="${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-lang/lua-5.1
	>=dev-libs/openssl-0.9.7"
DEPEND="${RDEPEND}
	dev-util/pkg-config"

#src_compile() {
#squish --use-http
#}

src_install() {
	insinto $(pkg-config --variable INSTALL_LMOD lua)
	doins verse.lua || die
	dodoc doc/* || die
}
