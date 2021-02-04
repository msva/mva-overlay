# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

S="${WORKDIR}"
inherit font

SHA1="61cc2afcc4eca96efe7c6ebf178d39df"

DESCRIPTION="Open Font"
HOMEPAGE="http://openfontlibrary.org/font/consolamono"
SRC_URI="http://openfontlibrary.org/assets/downloads/${PN}/${SHA1}/${PN}.zip -> ${P}.zip"

LICENSE="OFL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"

DEPEND="
	app-arch/unzip
"
RDEPEND=""

FONT_SUFFIX="ttf"

RESTRICT="strip binchecks"

src_prepare() {
	mv "${S}"/'Consola Mono'/* "${S}"
	default
}
