# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Set of icons representing programming languages, designing & development tools"
HOMEPAGE="https://github.com/AndreLGava/font-awesome-extension"
SRC_URI="https://github.com/AndreLGava/font-awesome-extension/archive/v.${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"

IUSE="webfonts"

FONT_S="${S}/fonts"
FONT_SUFFIX="ttf"

src_unpack() {
	default
	mv "${WORKDIR}/${PN/ntaw/nt-aw}-v.${PV}" "${S}"
}

src_install() {
	font_src_install

	use webfonts && (
		insinto "/usr/share/webfonts/${PN}"
		doins fonts/${PN}.{svg,woff,eot}
	)
}
