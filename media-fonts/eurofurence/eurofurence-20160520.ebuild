# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Eurofurence, a clean sans-serif font"
HOMEPAGE="https://www.dafont.com/eurofurence.font"

SRC_URI="https://img.dafont.com/dl/?f=eurofurence -> ${P}.zip"
S="${WORKDIR}"

inherit font

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"

BDEPEND="app-arch/unzip"

RESTRICT="strip binchecks"

FONT_SUFFIX="ttf"
