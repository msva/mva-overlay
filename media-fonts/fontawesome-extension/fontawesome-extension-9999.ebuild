# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit font

if [[ "${PV}" =~ "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AndreLZGava/font-awesome-extension"
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
	SRC_URI="https://github.com/AndreLZGava/font-awesome-extension/archive/v.${PV}.tar.gz -> ${P}.tar.gz"
	src_unpack() {
		default
		mv "${WORKDIR}/${PN/ntaw/nt-aw}-v.${PV}" "${S}" || die # Not sure if 0.3 only, or permanent
	}
fi

DESCRIPTION="Set of icons representing programming languages, designing & development tools"
HOMEPAGE="https://github.com/AndreLZGava/font-awesome-extension"

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
