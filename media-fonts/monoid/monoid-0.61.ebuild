# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

MONOISOME_SHA="f99f8de71dfd77b11fd1247e551ab6e33915f1e0"

DESCRIPTION="Open source coding font"
HOMEPAGE="https://larsenwork.com/monoid https://github.com/larsenwork/monoid"
SRC_URI="
	mirror://gentoo/${P}.tar.gz
	monoisome? ( https://github.com/larsenwork/monoid/raw/${MONOISOME_SHA}/Monoisome/Monoisome-Regular.ttf -> Monoisome-Regular-${MONOISOME_SHA}.ttf )
"

LICENSE="MIT OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~loong ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="+monoisome"
RESTRICT="binchecks strip"

FONT_SUFFIX="ttf"
DOCS=( Readme.md )

src_unpack() {
	default
	use monoisome && cp "${DISTDIR}/Monoisome-Regular-${MONOISOME_SHA}.ttf" "${S}/Monoisome-Regular.ttf"
}
