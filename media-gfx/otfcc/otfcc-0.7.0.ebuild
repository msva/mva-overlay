# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="Parses & writes SFNT structures."
HOMEPAGE="https://github.com/caryll/otfcc"
SRC_URI="https://github.com/caryll/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

IUSE="debug"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm ~mips"

DEPENDS="dev-util/premake:5"

src_prepare() {
	local a="x32" c="release";
	use debug && c="debug"
	(use amd64 || use arm64) && a="x64"

	sed -r -i \
		-e 's| make | $(MAKE) |' \
		-e "1iall: linux-${c}-${a}" \
		-e "s@(--cc=)[^ ]*@\1$(tc-get-compiler-type)@g" \
		"${S}/quick.make"

	# QA: We'll strip ourselves, do not strip for us!
	sed -r -i \
		-e '/filter "configurations:Release"/aflags { symbols "On" }\r' \
		"${S}"/premake5.lua
	# ^ QA

	ln -s quick.make Makefile

	default
}

src_install() {
	local a="x32" c="release";
	use debug && c="debug"
	(use amd64 || use arm64) && a="x64"

	dobin bin/"${c}-${a}"/*
}
