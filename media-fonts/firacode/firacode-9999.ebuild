# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font git-r3

DESCRIPTION="A programming font with ligatures"
HOMEPAGE="https://github.com/tonsky/FiraCode"
SRC_URI=""
EGIT_REPO_URI="https://github.com/tonsky/FiraCode"

LICENSE="OFL"
SLOT="0"
KEYWORDS=""
IUSE="truetype webfonts"

src_install() {
	local font_s=()
	font_s+=( "otf")
	use truetype && font_s+=( "ttf" "variable_ttf:ttf" )

	for f in ${font_s[@]}; do
		FONT_S="${S}/distr/${f%%:*}" FONT_SUFFIX="${f#*:}" font_src_install
	done

	use webfonts && (
		docinto html
		dodoc -r distr/{fira_code.css,specimen.html,woff{,2}}
#,eot}
	)
}
