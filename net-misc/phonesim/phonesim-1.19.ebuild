# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ofono/ofono-1.10.ebuild,v 1.2 2012/12/03 02:28:30 ssuominen Exp $

EAPI="5"

inherit multilib

DESCRIPTION="Phone Simulator for modem testing (oFono)"
HOMEPAGE="http://ofono.org/"
SRC_URI="mirror://kernel/linux/network/ofono/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="net-misc/ofono"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

