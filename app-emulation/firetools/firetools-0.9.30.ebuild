# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="Graphical user interface of app-emulation/firejail"
HOMEPAGE="https://l3net.wordpress.com/projects/firejail"
SRC_URI="mirror://sourceforge/${PN/tools/jail}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4 qt5"
REQUIRED_USE="^^ ( qt4 qt5 )"

DEPEND="
	app-emulation/firejail
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
	)
	x11-terms/xterm
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e 's/ strip.*;//' \
		Makefile.in
	sed -r -i \
		-e 's#(/usr/lib/qt)(/plugins/.*/)#\15\2#' \
		configure.ac
	eautoreconf
}
