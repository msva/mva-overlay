# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Author: mva $
EAPI="3"

inherit eutils subversion

DESCRIPTION="Datacard channel for Asterisk."
ESVN_REPO_URI="https://www.makhutov.org/svn/chan_datacard/trunk"
HOMEPAGE="http://www.makhutov.org/"
KEYWORDS=""

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND=">=net-misc/asterisk-1.6.2.0
	dev-libs/libxml2
	sys-libs/ncurses"
DEPEND="${RDEPEND}"

src_install() {
insinto /usr/$(get_libdir)/asterisk/modules
doins "${PN/*-/}.so"
insinto /etc/asterisk
doins etc/datacard.conf
newdoc README.txt README
newdoc LICENSE.txt LICENSE
}