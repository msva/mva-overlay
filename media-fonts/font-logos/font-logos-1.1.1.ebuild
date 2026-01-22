# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit font

DESCRIPTION="An icon font providing popular linux distro's logos"
HOMEPAGE="https://lukas-w.github.io/font-logos/"

LICENSE="unlicense"
SLOT="0"
if [[ "${PV}" == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lukas-w/font-logos"
else
	SRC_URI="https://github.com/lukas-w/font-logos/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86"
fi

IUSE="webfonts"

src_install() {
	FONT_S="${S}/assets" FONT_SUFFIX="ttf" font_src_install

	use webfonts && (
		insinto /usr/share/webfonts/${PN};
		doins assets/{${PN}-preview.html,preview.png,${PN}.{woff,eot,css,svg}}
	)
}
