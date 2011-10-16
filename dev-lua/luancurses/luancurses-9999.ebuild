# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit multilib git-2 eutils

DESCRIPTION="Lua NCurses Library"
HOMEPAGE=""
SRC_URI=""

EGIT_REPO_URI="git://github.com/msva/lua-ncurses.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=dev-lang/lua-5.1
	sys-libs/ncurses"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"