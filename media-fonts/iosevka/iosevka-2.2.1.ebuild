# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
# ^ font

S="${WORKDIR}"
inherit font

DESCRIPTION="Open source coding font"
HOMEPAGE="http://be5invis.github.io/Iosevka "
BASE_SRC_URI="https://github.com/be5invis/Iosevka/releases/download"
SRC_URI="
	${BASE_SRC_URI}/v${PV}/01-${P}.zip
	${BASE_SRC_URI}/v${PV}/02-${PN}-term-${PV}.zip
	${BASE_SRC_URI}/v${PV}/03-${PN}-type-${PV}.zip
	${BASE_SRC_URI}/v${PV}/04-${PN}-cc-${PV}.zip
	${BASE_SRC_URI}/v${PV}/05-${PN}-slab-${PV}.zip
	${BASE_SRC_URI}/v${PV}/06-${PN}-term-slab-${PV}.zip
	${BASE_SRC_URI}/v${PV}/07-${PN}-type-slab-${PV}.zip
	${BASE_SRC_URI}/v${PV}/08-${PN}-cc-slab-${PV}.zip
	ss? (
		${BASE_SRC_URI}/v${PV}/${PN}-ss01-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-ss02-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-ss03-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-ss04-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-ss05-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-ss06-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-ss07-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-ss08-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-ss09-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-ss10-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-ss11-${PV}.zip

		${BASE_SRC_URI}/v${PV}/${PN}-term-ss01-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-term-ss02-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-term-ss03-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-term-ss04-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-term-ss05-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-term-ss06-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-term-ss07-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-term-ss08-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-term-ss09-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-term-ss10-${PV}.zip
		${BASE_SRC_URI}/v${PV}/${PN}-term-ss11-${PV}.zip
	)
"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="ss web"
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND=""

FONT_S="${S}/ttf"
FONT_SUFFIX="ttf"

src_install() {
	font_src_install
	use web && (
		insinto /usr/share/webfonts/"${PN}"
		doins -r "${S}"/woff{,2}/*
	)
}
