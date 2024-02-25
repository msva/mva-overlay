# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

S="${WORKDIR}"
inherit font

BASE_SRC_URI="https://web.archive.org/web/20110108105420/http://code2000.net/"

DESCRIPTION="TrueType font covering big piece of Unicode (at time of its creation)"
HOMEPAGE="https://web.archive.org/web/20110108105420/code2000.net"
SRC_URI="
	${BASE_SRC_URI}/CODE2000.ZIP
	${BASE_SRC_URI}/CODE2001.ZIP
	${BASE_SRC_URI}/CODE2002.ZIP
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"

RESTRICT="strip binchecks mirror"

src_prepare() {
	for n in 0 1 2; do
		mv "$(find . -name CODE200$n.TTF)" "code200$n.ttf"
	done
	default
}
