# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

S="${WORKDIR}"
inherit font

DESCRIPTION="B20 Sans, a sans-serif font"
HOMEPAGE="http://www.dafont.com/b20-sans.font"

SRC_URI="http://img.dafont.com/dl/?f=b20_sans -> ${P}.zip"
LICENSE="OFL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"

IUSE=""
DEPEND="app-arch/unzip"
RDEPEND=""

RESTRICT="strip binchecks"

FONT_SUFFIX="ttf"
