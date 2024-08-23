# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tool for bisecting live ebuilds"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	dosbin "${FILESDIR}/ebuild-bisect"
}
