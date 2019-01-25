# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

IS_MULTILIB=true

inherit lua

DESCRIPTION="A simple tool, that help you to glue lua script with interpreter"
HOMEPAGE="http://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/index.html#srlua"
SRC_URI="http://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/ar/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
IUSE="+static-libs"

DOCS=(README)

all_lua_prepare() {
	local myeprepareargs=()
	use static-libs && myeprepareargs+=("STATIC=-static")
	cp "${FILESDIR}/Makefile" "${S}"
	lua_default
}

each_lua_test() {
	emake test.lua
}

each_lua_install() {
	local m_abi="${CHOST%%-*}"
	local l_abi="$(lua_get_lua)"
	exeinto "/usr/libexec/${PN}/${l_abi}.${m_abi}"
	doexe "${PN}"
	doexe "glue"
	dobin "${FILESDIR}"/glue
}
