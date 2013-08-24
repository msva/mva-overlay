# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-utils git-2

EGIT_REPO_URI="https://github.com/irungentoo/ProjectTox-Core"

DESCRIPTION="Free as in freedom Skype replacement"
HOMEPAGE="http://tox.im"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="-*"
IUSE=""

RDEPEND="sys-libs/ncurses[unicode]"
DEPEND="${RDEPEND}"
AUTOTOOLS_AUTORECONF="yes"

src_configure() {
	local myeconfargs=(
		--disable-tests
		--disable-dht-bootstrap-daemon
	)
	autotools-utils_src_configure
}

pkg_postinst() {
	elog "DHT node list is available via https://gist.github.com/Proplex/6124860"
	elog "or in #tox @ irc.freenode.org"
}
