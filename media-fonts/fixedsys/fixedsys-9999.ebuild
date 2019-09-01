# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit font git-r3

DESCRIPTION="Fixedsys Excelsior font with programming ligatures"
HOMEPAGE="https://github.com/kika/fixedsys"
SRC_URI=""
EGIT_REPO_URI="https://github.com/kika/fixedsys"

LICENSE="OFL"
SLOT="0"
KEYWORDS=""

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
