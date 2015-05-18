# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; $

EAPI="5"

inherit font

DESCRIPTION="TrueType font covering all of the CJK ideographs in the Basic Multilingual Plane of Unicode"
HOMEPAGE="no"
SRC_URI="code2000.zip
	code2001.zip
	code2002.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"

DEPEND="$DEPEND
	app-arch/unzip
"
RDEPEND=""

FONT_SUFFIX="ttf"
S="${WORKDIR}"
FONT_S="${S}"

RESTRICT="strip binchecks fetch mirror"

src_prepare() {
	for n in 0 1 2; do
		mv "$(find . -name CODE200$n.TTF)" "code200$n.ttf"
	done
}
