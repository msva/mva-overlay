# Copyright 1999-2017 Gentoo Foundation
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
IUSE="web"
RESTRICT="binchecks strip"

DEPEND="
	net-libs/nodejs
	media-gfx/fontforge
	media-gfx/ttfautohint
	media-gfx/otfcc
	web? (
		media-gfx/sfnt2woff
		media-gfx/woff2
	)
	"
RDEPEND=""

FONT_S="${S}/fonts_dist"
FONT_SUFFIX="ttf"

src_unpack() {
	git-r3_src_unpack

### Logically it should reside in src_compile or src_prepare part.
### But due to FEATURES=network-sandbox it fails there.
	pushd "${S}" &>/dev/null
	npm install
	popd &>/dev/null
###
}

src_compile() {
	local myemageargs=()
	myemageargs+=(start)
	use web && myemageargs+=(web)
	emake "${myemageargs[@]}"
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
