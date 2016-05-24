# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit font

DESCRIPTION="Fixedsys Excelsior font with programming ligatures"
HOMEPAGE="https://github.com/kika/fixedsys"
SRC_URI="https://github.com/kika/fixedsys/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL"
SLOT="0"
KEYWORDS="x86 amd64 mips arm"

FONT_SUFFIX="ttf"

src_prepare() {
	sed -i \
		-e '3,$d' \
		Makefile
	default
}
