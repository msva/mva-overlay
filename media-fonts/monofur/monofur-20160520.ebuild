# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="Monofur, a good fixed width font for development"
HOMEPAGE="http://www.dafont.com/monofur.font"

SRC_URI="http://img.dafont.com/dl/?f=monofur -> ${P}.zip"
LICENSE="free"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"

IUSE=""
DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"
FONT_SUFFIX="ttf"
FONT_S="${S}"

RESTRICT="strip binchecks"
