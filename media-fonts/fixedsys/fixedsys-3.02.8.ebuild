# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="Fixedsys Excelsior font with programming ligatures"
HOMEPAGE="https://github.com/kika/fixedsys"
SRC_URI="https://github.com/kika/fixedsys/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"

FONT_SUFFIX="ttf"

DEPEND="dev-python/fonttools"

src_prepare() {
	sed -i \
		-e '/cp /d' \
		-e '/rm /d' \
		-e '/atsutil /d' \
		Makefile
	default
}
