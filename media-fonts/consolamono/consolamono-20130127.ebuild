# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit font

SHA1="61cc2afcc4eca96efe7c6ebf178d39df"

DESCRIPTION="Open Font"
HOMEPAGE="http://openfontlibrary.org/font/consolamono"
SRC_URI="http://openfontlibrary.org/assets/downloads/${PN}/${SHA1}/${PN}.zip -> ${P}.zip"

LICENSE="OFL"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86"

DEPEND="
	app-arch/unzip
"
RDEPEND=""

FONT_SUFFIX="ttf"
S="${WORKDIR}/Consola Mono"
FONT_S="${S}"

RESTRICT="strip binchecks"
