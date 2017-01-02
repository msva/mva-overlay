# Copyright 1999-2017 Gentoo Foundation
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

src_prepare() {
	sed -i \
		-e '3,$d' \
		Makefile
	default
}
