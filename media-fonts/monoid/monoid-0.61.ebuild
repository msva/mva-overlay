# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

MONOISOME_SHA="0abc451aaaa650198c065cd97aea4e7895931227"

DESCRIPTION="Open source coding font"
HOMEPAGE="http://larsenwork.com/monoid https://github.com/larsenwork/monoid"
SRC_URI="
	mirror://gentoo/${P}.tar.gz
	monoisome? ( https://github.com/larsenwork/monoid/raw/${MONOISOME_SHA}/Monoisome/Monoisome-Regular.ttf -> Monoisome-Regular-${MONOISOME_SHA}.ttf )
"

LICENSE="MIT OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="+monoisome"
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""

FONT_SUFFIX="ttf"
DOCS="Readme.md"

src_unpack() {
	default
	use monoisome && cp "${DISTDIR}/Monoisome-Regular-${MONOISOME_SHA}.ttf" "${S}/Monoisome-Regular.ttf"
}
