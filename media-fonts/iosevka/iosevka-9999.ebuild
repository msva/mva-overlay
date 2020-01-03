# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
# ^ font

inherit font git-r3

DESCRIPTION="Open source coding font"
HOMEPAGE="https://be5invis.github.io/Iosevka"
EGIT_REPO_URI="https://github.com/be5invis/Iosevka"
SRC_URI=""

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS=""
IUSE="web"
RESTRICT="binchecks strip network-sandbox"

DEPEND="
	net-libs/nodejs
	media-gfx/fontforge
	media-gfx/ttfautohint
	media-gfx/otfcc
	web? (
		media-gfx/sfnt2woff
		media-libs/woff2
	)
	"
RDEPEND=""

FONT_S="${S}/fonts_dist"
FONT_SUFFIX="ttf"

src_compile() {
	npm install
	npm run build -- contents::iosevka
}

src_install() {
	mkdir -p "${FONT_S}"
	find "${S}"/dist/*${PN}*/ttf/ -name '*.ttf' -print0 | xargs -0 mv -u -t "${FONT_S}"
	font_src_install
	use web && (
		insinto /usr/share/webfonts/${PN}
		doins -r dist/iosevka*/woff{,2}/*
	)
}
