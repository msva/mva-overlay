# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

LANGS=" en ru"

inherit multilib toolchain-funcs flag-o-matic git-2 eutils

DESCRIPTION="Lua Crypto Library"
HOMEPAGE=""
SRC_URI=""

EGIT_REPO_URI="git://github.com/msva/lua-json.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"
IUSE+="${LANGS// / linguas_}"

RDEPEND=">=dev-lang/lua-5.1
	dev-lua/luasocket"
DEPEND="${RDEPEND}"
#	dev-util/pkg-config"

src_install() {
	if use doc; then
		dodoc README || die "dodoc (REAMDE) failed"
		for x in ${LANGS}; do
			if use linguas_${x}; then
				dohtml -r doc/"${x}" || die "dohtml failed"
			fi
		done
	fi
	if use examples; then
		insinto /usr/share/doc/"${P}"
		doins -r examples	
	fi
	default
}
