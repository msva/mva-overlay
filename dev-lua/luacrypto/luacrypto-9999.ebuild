# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

LANGS=" en ru"

inherit multilib toolchain-funcs flag-o-matic eutils git-2

DESCRIPTION="Lua Crypto Library"
HOMEPAGE="https://github.com/msva/lua-crypto"
SRC_URI=""

EGIT_REPO_URI="git://github.com/msva/lua-crypto.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"
IUSE+="${LANGS// / linguas_}"

RDEPEND=">=dev-lang/lua-5.1
	>=dev-libs/openssl-0.9.7"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	if use doc; then
		dodoc README || die "dodoc (REAMDE) failed"
		for x in ${LANGS}; do
			if use linguas_${x}; then
				dohtml -r doc/${x} || die "dohtml failed"
			fi
		done
	fi
	default
}
