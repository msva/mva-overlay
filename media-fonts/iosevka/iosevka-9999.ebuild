# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font git-r3

DESCRIPTION="Open source coding font"
HOMEPAGE="https://be5invis.github.io/Iosevka"
EGIT_REPO_URI="https://github.com/be5invis/Iosevka"
SRC_URI=""

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS=""
IUSE="webfonts"
RESTRICT="binchecks strip"

DEPEND="
	net-libs/nodejs
	media-gfx/fontforge
	media-gfx/ttfautohint
	media-gfx/otfcc
	webfonts? (
		media-gfx/sfnt2woff
		media-gfx/woff2_compress
	)
	"
RDEPEND=""

FONT_S="${S}/distdir"
FONT_SUFFIX="ttf"

src_prepare() {
	default
	npm install
}

src_compile() {
	default
	use webfonts && make webfonts
}

src_install() {
	mkdir -p "${FONT_S}"
	find "${S}" -name '*.ttf' -print0 | xargs -0 mv -t "${FONT_S}"
	font_src_install
}
