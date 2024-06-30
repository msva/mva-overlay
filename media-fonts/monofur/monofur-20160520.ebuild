# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

S="${WORKDIR}"
inherit font

DESCRIPTION="Monofur, a good fixed width font for development"
HOMEPAGE="https://www.dafont.com/monofur.font"

SRC_URI="https://img.dafont.com/dl/?f=monofur -> ${P}.zip"
LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"

RESTRICT="strip binchecks"
