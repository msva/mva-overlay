# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

S="${WORKDIR}"
inherit font unpacker

DESCRIPTION="Open source coding font"
HOMEPAGE="http://be5invis.github.io/Iosevka "
BASE_SRC_URI="https://github.com/be5invis/Iosevka/releases/download"
SRC_URI="
	${BASE_SRC_URI}/v${PV}/${PN}-pack-${PV}.zip
"
#	${BASE_SRC_URI}/v${PV}/01-${P}.zip
#	${BASE_SRC_URI}/v${PV}/02-${PN}-term-${PV}.zip
#	${BASE_SRC_URI}/v${PV}/03-${PN}-type-${PV}.zip
#	${BASE_SRC_URI}/v${PV}/04-${PN}-cc-${PV}.zip
#	${BASE_SRC_URI}/v${PV}/05-${PN}-slab-${PV}.zip
#	${BASE_SRC_URI}/v${PV}/06-${PN}-term-slab-${PV}.zip
#	${BASE_SRC_URI}/v${PV}/07-${PN}-type-slab-${PV}.zip
#	${BASE_SRC_URI}/v${PV}/08-${PN}-cc-slab-${PV}.zip
#	${BASE_SRC_URI}/v${PV}/09-${PN}-hooky-${PV}.zip
#	${BASE_SRC_URI}/v${PV}/10-${PN}-hooky-term-${PV}.zip
#	${BASE_SRC_URI}/v${PV}/11-${PN}-zshaped-${PV}.zip
#	${BASE_SRC_URI}/v${PV}/12-${PN}-zshaped-term-${PV}.zip
#"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""

FONT_SUFFIX="ttf"
