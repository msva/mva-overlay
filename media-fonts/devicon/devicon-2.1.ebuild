# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="Set of icons representing programming languages, designing & development tools"
HOMEPAGE="https://github.com/konpa/devicon"

if [[ "${PV}" =~ "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/konpa/devicon"
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
	SRC_URI="https://github.com/konpa/devicon/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"

IUSE="icons webfonts"

FONT_S="${S}/fonts"
FONT_SUFFIX="ttf"

src_install() {
	font_src_install

	if use icons; then
		insinto /usr/share/icons
		newins icons "${PN}"
	fi

	use webfonts && (
		insinto "/usr/share/webfonts/${PN}"
		doins fonts/${PN}.{svg,woff,eot}
	)
}
