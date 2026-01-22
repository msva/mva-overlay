# Copyright 2026 mva
# Distributed under the terms of the Public Domain or CC0 License

EAPI=8

inherit git-r3 autotools

DESCRIPTION="utilities for manipulating MPQ archives used in Blizzard games"
HOMEPAGE="https://libmpq.org/"
EGIT_REPO_URI="https://github.com/msva/${PN}"

LICENSE="MIT"
SLOT="0"

DEPEND="
	games-util/libmpq
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}
