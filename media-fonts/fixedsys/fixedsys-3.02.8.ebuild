# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

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

LICENSE="OFL"
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
