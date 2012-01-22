# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit multilib eutils git-2

DESCRIPTION="Lua NCurses Library"
HOMEPAGE="https://github.com/msva/lua-ncurses"
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