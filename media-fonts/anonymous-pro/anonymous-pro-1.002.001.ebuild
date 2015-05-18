# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from mva overlay; $

EAPI="5"

inherit font

SHA1="bb5141b20b9d69b3190be03e5706c8b7"

DESCRIPTION="A monospace font that is ideal for use in terminals, text editors, and programming environments."
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
S="${WORKDIR}/AnonymousPro-${PV}"
FONT_S="${S}"

RESTRICT="strip binchecks"
