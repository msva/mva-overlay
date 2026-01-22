# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit font

DESCRIPTION="Set of icons representing programming languages, designing & development tools"
HOMEPAGE="https://github.com/devicons/devicon"

if [[ "${PV}" =~ "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/devicons/devicon"
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86"
	SRC_URI="https://github.com/devicons/devicon/archive/v${PV}.tar.gz -> ${P}.tar.gz"
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
