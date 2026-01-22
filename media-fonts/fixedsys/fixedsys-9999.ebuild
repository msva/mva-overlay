# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8
inherit font

DESCRIPTION="Fixedsys Excelsior font with programming ligatures"
HOMEPAGE="https://github.com/kika/fixedsys"

if [[ "${PV}" =~ "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kika/fixedsys"
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
	SRC_URI="https://github.com/kika/fixedsys/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="OFL-1.1"
SLOT="0"

FONT_SUFFIX="ttf"

DEPEND="dev-python/fonttools"

src_prepare() {
	sed -i \
		-e '/cp /d' \
		-e '/rm /d' \
		-e '/atsutil /d' \
		Makefile
	default
}
