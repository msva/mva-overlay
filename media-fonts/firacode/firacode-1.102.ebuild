# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

S="${WORKDIR}/${P^^[cf]}"
inherit font

DESCRIPTION="A programming font with ligatures"
HOMEPAGE="https://github.com/tonsky/FiraCode"
SRC_URI="https://github.com/tonsky/FiraCode/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"

FONT_SUFFIX="otf"
