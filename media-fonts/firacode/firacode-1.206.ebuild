# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

S="${WORKDIR}/${P^^[cf]}"
inherit font

DESCRIPTION="A programming font with ligatures"
HOMEPAGE="https://github.com/tonsky/FiraCode"
SRC_URI="https://github.com/tonsky/FiraCode/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"

IUSE="truetype webfonts"

src_install() {
	local font_s=()
	font_s+=( "otf")
	use truetype && font_s+=( "ttf" )

	for f in ${font_s[@]}; do
		FONT_S="${S}/distr/${f}" FONT_SUFFIX="${f}" font_src_install
	done

	use webfonts && (
		docinto html
		dodoc -r distr/{fira_code.css,specimen.html,woff{,2},eot}
	)
}
