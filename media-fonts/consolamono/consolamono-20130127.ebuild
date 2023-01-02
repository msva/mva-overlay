# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

S="${WORKDIR}"
inherit font

SHA1="61cc2afcc4eca96efe7c6ebf178d39df"

DESCRIPTION="Open Font by Wojciech Kalinowski"
HOMEPAGE="http://openfontlibrary.org/font/consolamono"
SRC_URI="http://openfontlibrary.org/assets/downloads/${PN}/${SHA1}/${PN}.zip -> ${P}.zip"

LICENSE="OFL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"

RESTRICT="strip binchecks"

src_prepare() {
	mv "${S}"/'Consola Mono'/* "${S}"
	default
}
