# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools eutils git-2

DESCRIPTION="Lua cURL Library"
HOMEPAGE="https://github.com/msva/lua-curl"
SRC_URI=""

#EGIT_REPO_URI="git://github.com/juergenhoetzel/Lua-cURL.git"
EGIT_REPO_URI="git://github.com/msva/lua-curl.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

RDEPEND=">=dev-lang/lua-5.1"
DEPEND="${RDEPEND}
	net-misc/curl"

src_prepare() {
	eautoreconf
	epatch_user
}

src_install() {
	if use doc; then
		dodoc -r doc || die "dodoc failed"
	fi
	if use examples; then
		insinto /usr/share/doc/"${P}";
		doins -r examples
	fi
	default
}
