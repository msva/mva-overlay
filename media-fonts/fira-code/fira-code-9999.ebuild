# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit font git-r3

DESCRIPTION="A programming font with ligatures"
HOMEPAGE="https://github.com/tonsky/FiraCode"
EGIT_REPO_URI="https://github.com/tonsky/FiraCode"

LICENSE="OFL-1.1"
SLOT="0"
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
