# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit multilib

DESCRIPTION="Phone Simulator for modem testing (oFono)"
HOMEPAGE="http://ofono.org/"
SRC_URI="mirror://kernel/linux/network/ofono/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="net-misc/ofono"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
