# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools eutils git-2

DESCRIPTION="Lua cURL Library"
HOMEPAGE="http://ittner.github.com/lua-iconv"
SRC_URI=""

EGIT_REPO_URI="git://github.com/ittner/lua-iconv.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-lang/lua-5.1"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	epatch_user
}