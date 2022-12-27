# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tool for bisecting live ebuilds"
HOMEPAGE="https://www.gentoo.org/no-homepage"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_install() {
	dosbin "${FILESDIR}/ebuild-bisect"
}
