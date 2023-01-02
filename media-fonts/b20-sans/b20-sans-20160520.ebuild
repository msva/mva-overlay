# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

S="${WORKDIR}"
inherit font

DESCRIPTION="B20 Sans, a sans-serif font"
HOMEPAGE="http://www.dafont.com/b20-sans.font"

SRC_URI="http://img.dafont.com/dl/?f=b20_sans -> ${P}.zip"
LICENSE="OFL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"

BDEPEND="app-arch/unzip"

RESTRICT="strip binchecks"

FONT_SUFFIX="ttf"
