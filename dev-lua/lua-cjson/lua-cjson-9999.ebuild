# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit multilib toolchain-funcs flag-o-matic git-2 eutils

DESCRIPTION="Lua JSON Library, written in C"
HOMEPAGE="http://www.kyne.com.au/~mark/software/lua-cjson.php"
SRC_URI=""

EGIT_REPO_URI="git://github.com/msva/lua-cjson.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples"

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit )"
DEPEND="${RDEPEND}"

src_install() {
	if use examples; then
		insinto /usr/share/doc/"${P}"
		doins -r tests
	fi
	default
}
