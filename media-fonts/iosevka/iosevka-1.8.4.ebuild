# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

S="${WORKDIR}"
inherit font unpacker

DESCRIPTION="Open source coding font"
HOMEPAGE="http://be5invis.github.io/Iosevka "
BASE_SRC_URI="https://github.com/be5invis/Iosevka/releases/download/"
SRC_URI="
	${BASE_SRC_URI}/v${PV}/01.${P}.7z
	${BASE_SRC_URI}/v${PV}/02.${PN}-term-${PV}.7z
	${BASE_SRC_URI}/v${PV}/03.${PN}-cc-${PV}.7z
	${BASE_SRC_URI}/v${PV}/04.${PN}-slab-${PV}.7z
	${BASE_SRC_URI}/v${PV}/05.${PN}-term-slab-${PV}.7z
	${BASE_SRC_URI}/v${PV}/06.${PN}-cc-slab-${PV}.7z
	${BASE_SRC_URI}/v${PV}/07.${PN}-hooky-${PV}.7z
	${BASE_SRC_URI}/v${PV}/08.${PN}-term-hooky-${PV}.7z
	${BASE_SRC_URI}/v${PV}/09.${PN}-zshaped-${PV}.7z
	${BASE_SRC_URI}/v${PV}/10.${PN}-term-zshaped-${PV}.7z
"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""

FONT_SUFFIX="ttf"
