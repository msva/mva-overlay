# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; $

EAPI="5"

inherit googlecode qt4-r2

DESCRIPTION="An open-source Qt4 implementation of IP Messenger for linux."

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=x11-libs/qt-core-4.3
	>=x11-libs/qt-gui-4.3
"
DEPEND="${RDEPEND}"

export PREFIX=/usr

src_compile(){
	emake QMAKE=qmake LRELEASE=lrelease || die
}
