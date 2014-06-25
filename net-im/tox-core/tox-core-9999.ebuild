# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools-multilib git-2

EGIT_REPO_URI="https://github.com/irungentoo/ProjectTox-Core"

DESCRIPTION="Free as in freedom Skype replacement"
HOMEPAGE="http://tox.im"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="net-libs/libsodium[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
AUTOTOOLS_AUTORECONF="yes"
AUTOTOOLS_IN_SOURCE_BUILD="yes"

src_configure() {
	local myeconfargs=(
		--disable-tests
		--disable-dht-bootstrap-daemon
		--disable-ntox
	)
	autotools-multilib_src_configure
}

pkg_postinst() {
	elog "DHT node list is available via https://gist.github.com/Proplex/6124860"
	elog "or in #tox @ irc.freenode.org"
}
