# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; $

EAPI="5"

inherit font

SHA1="61cc2afcc4eca96efe7c6ebf178d39df"

DESCRIPTION=""
HOMEPAGE="http://openfontlibrary.org/font/${PN}"
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