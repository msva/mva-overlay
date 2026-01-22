# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

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
