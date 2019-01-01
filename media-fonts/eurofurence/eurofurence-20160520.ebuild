# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

S="${WORKDIR}"
inherit font

DESCRIPTION="Eurofurence, a clean sans-serif font"
HOMEPAGE="http://www.dafont.com/eurofurence.font"

SRC_URI="http://img.dafont.com/dl/?f=eurofurence -> ${P}.zip"
LICENSE="OFL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"

IUSE=""
DEPEND="app-arch/unzip"
RDEPEND=""

RESTRICT="strip binchecks"

FONT_SUFFIX="ttf"
