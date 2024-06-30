# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

MONOISOME_SHA="0673c8d6728df093faee9f183b6dfa62939df8c0"
MONOID_SHA="2db2d289f4e61010dd3f44e09918d9bb32fb96fd"

DESCRIPTION="Open source coding font"
HOMEPAGE="https://larsenwork.com/monoid/ https://github.com/larsenwork/monoid"

GH="https://github.com/larsenwork/${PN}"
SRC_URI="
	https://cdn.rawgit.com/larsenwork/monoid/${MONOID_SHA}/Monoid.zip
	monoisome? ( ${GH}/raw/${MONOISOME_SHA}/Monoisome/Monoisome-Regular.ttf -> Monoisome-Regular-${MONOISOME_SHA}.ttf )
"
BDEPEND="app-arch/unzip"

LICENSE="MIT OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~loong ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="monoisome"
RESTRICT="binchecks strip"

FONT_SUFFIX="ttf"
DOCS=( Readme.md )

S="${WORKDIR}"

src_unpack() {
	default
	use monoisome && cp "${DISTDIR}/Monoisome-Regular-${MONOISOME_SHA}.ttf" "${S}/Monoisome-Regular.ttf"
}
