# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 font

DESCRIPTION="Set of icons representing programming languages, designing & development tools"
HOMEPAGE="https://github.com/AndreLGava/font-awesome-extension"
EGIT_REPO_URI="https://github.com/AndreLGava/font-awesome-extension"

LICENSE="MIT"
SLOT="0"

IUSE="webfonts"

FONT_S="${S}/fonts"
FONT_SUFFIX="ttf"

src_install() {
	font_src_install

	use webfonts && (
		insinto "/usr/share/webfonts/${PN}"
		doins fonts/${PN}.{svg,woff,eot}
	)
}
