# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Open Font by Wojciech Kalinowski"
HOMEPAGE="https://fontlibrary.org/en/font/consolamono"

SHA1="61cc2afcc4eca96efe7c6ebf178d39df"
SRC_URI="https://fontlibrary.org/assets/downloads/${PN}/${SHA1}/${PN}.zip -> ${P}.zip"
S="${WORKDIR}"

inherit font

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"

RESTRICT="strip binchecks"

src_prepare() {
	mv "${S}"/'Consola Mono'/* "${S}"
	default
}
